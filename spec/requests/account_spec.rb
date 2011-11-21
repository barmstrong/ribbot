require 'spec_helper'

describe "Account" do
  it "should let you view all pages" do
    u, f, p, c = create_ufpc
    u2 = create_user # regular member
    
    set_subdomain f.subdomain
    
    visit account_comments_path
    current_path.should_not == account_comments_path
    
    signin_as u
    
    visit account_comments_path
    current_path.should == account_comments_path
    visit account_posts_path
    current_path.should == account_posts_path
    visit account_profile_path
    current_path.should == account_profile_path
    visit account_users_path
    current_path.should == account_users_path
    visit account_settings_path
    current_path.should == account_settings_path
    
    signin_as u2
    visit account_comments_path
    current_path.should == account_comments_path
    visit account_users_path
    current_path.should_not == account_users_path
  end

end
