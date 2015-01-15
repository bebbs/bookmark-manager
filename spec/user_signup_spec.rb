require 'spec_helper'
require_relative '../app/helpers/session'
include SessionHelpers

feature "User signs up" do
  
  scenario "when being a new user visiting the site" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, josh@test.com")
    expect(User.first.email).to eq("josh@test.com")
  end

  scenario "with a password that doesn't match" do
    expect{sign_up('a@a.com', 'pass', 'wrong')}.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Password does not match the confirmation")
  end

  scenario "with an email that is already registered" do
    expect{sign_up}.to change(User, :count).by(1)
    expect{sign_up}.to change(User, :count).by(0)
    expect(page).to have_content("This email is already taken")
  end

end
