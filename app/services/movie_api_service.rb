class MovieApiService
  def self.upcoming_movies
    upcoming_movies = []
    page_number = 1
    until upcoming_movies.count == 40
      break if page_number == 5

      response = conn.get('/3/movie/upcoming') do |movie|
        movie.params[:page] = page_number
      end

      movies = parse_data(response)
      upcoming_movies.concat(movies[:results])
      page_number += 1
    end
    upcoming_movies
  end

  def self.top_rated_movies
    top_movies = []
    page_number = 0

    until top_movies.count == 40
      page_number += 1
      response = conn.get('/3/movie/top_rated') do |movie|
        movie.params[:page] = page_number
      end

      title_data = parse_data(response)

      top_movies.concat(title_data[:results])
    end
    top_movies
  end

  def self.movie_search(query)
    titles = []
    page_number = 0

    2.times do
      page_number += 1
      response = conn.get('/3/search/movie') do |req|
        req.params[:query] = query
        req.params[:page] = page_number
      end
      title_data = parse_data(response)
      titles << title_data[:results]
    end

    titles.flatten
  end

  def self.get_movie_details(movie_id)
    response = conn.get("/3/movie/#{movie_id}") do |movie|
      movie.params[:append_to_response] = 'reviews,credits,similar'
    end
    parse_data(response)
  end

  def self.conn
    Faraday.new(url: 'https://api.themoviedb.org') do |faraday|
      faraday.params[:api_key] = Rails.application.credentials.dig(:MOVIE_DB_API_KEY)
    end
  end

  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
