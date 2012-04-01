require 'spec_helper'

describe "Signup" do
  it "should work from homepage" do
    visit root_path
    current_path.should == root_path
    
    fill_in 'user_email', :with => "user@example.com"
    fill_in 'user_password', :with => "test123"
    fill_in 'subdomain', :with => "testing1"
    
    assert_difference "User.count" do
      assert_difference "Forum.count" do
        assert_difference "emails_sent" do
          find('form#new_user .btn-primary').click
        end
      end
    end
    
    user = User.last
    user.verified?.should == false
    user.admin_of?(Forum.last).should == true
    
    current_path.should == verifications_path
    last_email.body.should include(verification_path(user.verification_token))
    
    visit verification_path(user.verification_token)
    user.reload.verified?.should == true
  end
  
  it "should work form signup page on subdomain" do
    f = create_forum
    visit signin_url(:subdomain => f.subdomain)
    fill_in 'user_email', :with => "user@example.com"
    fill_in 'user_password', :with => "test123"
    
    assert_difference "User.count" do
      assert_no_difference "Forum.count" do
        assert_difference "emails_sent" do
          find('form#new_user .btn').click
        end
      end
    end
    user = User.last
    user.verified?.should == false
    current_path.should == verifications_path
  end

end
