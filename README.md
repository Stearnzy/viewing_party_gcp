# Viewing Party - Google Cloud Platform
__Below this section is the original project README__

## Purpose
This copied repo catalogs my attempt to deploy this application on the Google Cloud Platform's App Engine.  This process is mostly following [this tutorial](https://www.tastyvar.com/rails-appengine).  The deployed application can be found at https://viewing-party-gcp.wm.r.appspot.com/

## Struggles
### Travis CI
  * Authorizing CLI tool with GitHub credential login:
    * I struggled a bit with authorizing Travis CI CLI tool during this step:
    ```
    In order to safely upload these credentials to GitHub and Travis CI, we need to encrypt them using the Travis CI Command Line Client.

    You can install the client by running:

    $ gem install travis

    After installing the client, authorize it with Travis CI by running:

    $ travis login --com
    ```
    * I worked around this by generating a personal access token with user and repo scopes and entering it this way on the command line:
    ```
    travis login --pro --github-token yourGitHubTokenHere
    ```

  * Builds failing:
    * Checking build logs shows that the necessary `mimemagic` dependency could not be found.  After some research, I saw that this is a current problem for a lot of Rails users, with no clear solution besides updating.  I was also getting this `mimemagic` error on my local machine when trying to deploy to GCP, and that was resolved with removing the specified version of Rails in the Gemfile followed by a `bundle update`.  After this, deployment was successful to GCP and the home page works, but builds on Travis are still hung up on this issue despite a push to main on GitHub.


### PostgreSQL Database Deployment
I ended up successfully deploying the application to GCP and visiting the home page after the `bundle update` mentioned previously, but trying to create an account or log in resulted in an error.  Checking the logs, I saw the error `PG::UndefinedTable: ERROR: relation "users" does not exist`, hinting at a database migration issue.  To fix this, I ended up manually making the migration from the command line using `bundle exec rake appengine:exec -- bundle exec rake db:migrate`.

### Storing API Key for TheMovieDB
After resolving the database issue, I was now getting errors due to GCP not having my API key.  I encrypted it in the credentials file, and after some researching I ended up substituting the environment variable call in the file `movie_api_service.rb` with `Rails.application.credentials.dig(:MOVIE_DB_API_KEY)`.  I am sure there is a more direct way to do this on GCP itself, but with respect to the limited time I had to get this running, this works and is still maintaining secure information.

### Lessons

  * Credentials and Master files 
    * Credentials.yml.enc contain your secrets like API keys and can be pushed to GitHub as the file is already encrypted
    * Master.key contains a generated key to decrypt the Credentials file on a platform like GCP
      * Running the following auto-generates these files and inserts a key into master.key
      ``` 
      EDITOR=code rails credentials:edit
      ```
 * GCP had many different API service one can add to a project.  
   * Cloud Build is a CI/CD platform similar to Travis CI that performs builds and runs automated tests to ensure an application can be deployed effectively.
   * Cloud SQL is a fully-functional relational database service to which I was able to create an instance of a PostgreSQL database necessary for my application.
   * Cloud SDK is a command line tool that allowed me to run configurations and deploy my application through the `gcloud` command from my local terminal.
 
 
***
***
***


# Original README

This is a three-person group project as part of Turing School of Software and Design's Back-End Engineering program, Module 3.  We utilized our knowledge in Ruby on Rails, ActiveRecord and PostgreSQL to build a website for creating movie watch parties created by users, for users.  We introduced our new knowledge of consuming APIs to pull movie data from TheMovieDB's API.

#### [Visit Deployed Application](https://viewing-party-13.herokuapp.com/)

## Table of Contents

  - [Introduction](#introduction)
  - [Functional Overview](#functional-overview)
  - [Setup](#setup)
  - [Runing the tests](#running-the-tests)
  - [Deployment](#deployment)
  - [Authors](#authors)

## Introduction
  * [Project Requirements](https://backend.turing.io/module3/projects/viewing_party/index)
  * [Original Project Repo](https://github.com/turingschool-examples/viewing_party)

## Functional Overview

In this website, a visitor can register as a user to begin.  Once an account is created, that user is brought to their dashboard where they can see a bar to search for friends and and a space to see what parties they are a part of.  Clicking on the `discover` button, they get an option to either search movies by title or to discover the forty top-rated movies, according to the API.  Clicking on a movie title in the results displays that movie's information, and the user can choose to create a viewing party.  On this form, they can extend the viewing party duration to be longer than the movie runtime, select a date and time for the party, as well as friends to invite.  The details of this created party then show up on both the host user's and invited users' pages, with respective labels showing their role in the party.

### Database Structure

<img src="https://i.postimg.cc/d324DsL9/Viewing-Party-DB-Schema.png" alt="viewing_party_schema">

This project introduced us to the concept of a self-referential relationship.  We utilized this relationship to embody a 'follower' style of friendship between users.  When User 1 searches for and adds User 2 to their friends list, User 2 does not show User 1 in his or her friends list, but User 2 does show any viewing party listed on their dashboard that User 1 has invited him or her to.

There is a many-to-many relationship set up between Users and Parties through the Guests table.  The host of the party is determined by including their ID in the parties table when they create the viewing party.  This allows for a user to both attend and host multiple parties.

To save space in our database, we rely on API calls to provide movie data and store that information to the database when that movie's information is viewed.  This keeps us from initializing our database with thousands of movies' details from the get-go.

## Setup

### Prerequisites

These setup instructions are for Mac OS.

This project requires the use of `Ruby 2.5.3` and `Rails 5.2.4.3`.
We also use `PostgreSQL` as our database.

### Local Setup

To setup locally, follow these instructions:
  * __Fork & Clone Repo__
    * Fork this repo to your own GitHub account.
    * Create a new directory locally or `cd` into whichever directory you wish to clone down to.
    * Enter `git clone git@github.com:<<YOUR GITHUB USERNAME>>/viewing_party.git`
  * __Install Gems__
    * Run `bundle install` to install all gems in the Gemfile
  * __Set Up Local Database and Migrations__
    * Run `rails db:create`
    * Run `rake db:migrate`

## Running the tests

Run the command `bundle exec rspec` in the terminal.  You should see all passing tests.

## Deployment

The current live deployment of this project can be found [here](https://viewing-party-13.herokuapp.com/).

To run this site locally on your device, enter `rails server` in the terminal to start up a local server, then visit `http://localhost:3000/` in your browser.

## Contributors

  - **Roberto Basulto** - *Turing Student* - [Github Profile](https://github.com/Eternal-Flame085) - [Turing Alum Profile] - [LinkedIn](https://www.linkedin.com/in/roberto-basulto-9051941b9/)
  - **Sheryl Stillman** - *Turing Student* - [Github Profile](https://github.com/stillsheryl) - [Turing Alum Profile](https://alumni.turing.io/alumni/sheryl-stillman) - [LinkedIn](https://www.linkedin.com/in/sherylstillman1/)
  - **Zach Stearns** - *Turing Student* - [Github Profile](https://github.com/Stearnzy) - [Turing Alum Profile](https://alumni.turing.io/alumni/zach-stearns) - [LinkedIn](https://www.linkedin.com/in/zach-stearns/)

