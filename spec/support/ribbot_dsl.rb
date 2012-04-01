def signin_as user, password = 'test123'
  visit signin_path
  fill_in 'email', :with => user.email
  fill_in 'password', :with => password
  find('form#new_session .btn-primary').click
  
  current_path.should_not == signin_path
end

def signout
  visit root_path
  click_on 'Sign Out'
end