require 'rails_helper'

describe "As a visitor" do
  describe "When I visit the home page to log in" do
    it "I enter valid information and am redirected to my dashboard" do
      user = User.create!(first_name: 'Zach',
                          last_name: 'Stearns',
                          email: 'zach@email.com', 
                          password: 'password')

      visit root_path

      fill_in :email,	with: "#{user.email}"
      fill_in :password,	with: "#{user.password}"
      click_button 'Sign In'

      expect(current_path).to eq('/dashboard')
      expect(page).to have_content('Login Successful!')
    end

    it "When I attempt to log in with an email address that is not registered, I get an error" do
      visit root_path

      fill_in :email,	with: "bob@email.com"
      fill_in :password, with: "password"
      click_button 'Sign In'

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Please enter a valid email address.')
    end

    it "When I attempt to log in with an invalid password I get an error" do
      visit root_path

      fill_in :email, with: "zach@email.com"
      fill_in :password, with: "multipass"
      click_button 'Sign In'

      expect(current_path).to eq(root_path)
      expect(page).to have_content('Incorrect password, please try again.')
    end
  end
end
