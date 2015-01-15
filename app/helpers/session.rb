module SessionHelpers
  def sign_in(email, password)
    visit '/sessions/new'
    fill_in 'email', :with => email
    fill_in 'password', :with => password
    within('#signin-form') do
      click_button 'Sign in'
    end
  end

  def sign_up(email= "josh@test.com", password= "oranges", password_confirmation= "oranges")
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    within('#signup-form') do
      click_button "Sign up"
    end
  end
end