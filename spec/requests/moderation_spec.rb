require 'spec_helper'

describe "Comments" do
  
  before do
    @admin, @forum = create_user_with_forum
    @user = create_user
  end
  
  it "should require login to make a new comment", :js => true do
    assert_difference "Post.count" do
      create_post :user => @user, :forum => @forum
    end
    
    assert_difference "Comment.count" do
      create_comment :user => @user, :forum => @forum, :post => @post
    end
    
    set_subdomain @forum.subdomain
    signin_as @admin
    
    visit account_users_path
    p = Participation.where(:user_id => @user.id, :forum_id => @forum.id).first
    within("#participation_#{p.id}") do
      click_on 'Ban'
    end
    visit account_users_path # reload page
    p.reload.banned.should == true
    
    expect { create_post :user => @user, :forum => @forum                    }.to raise_error
    expect { create_comment :user => @user, :forum => @forum, :post => @post }.to raise_error
    
    visit account_users_path
    within("#participation_#{p.id}") do
      click_on 'Unban'
    end
    visit account_users_path # reload page
    p.reload.banned.should == false
    
    signin_as @user
    visit account_users_path
    current_path.should_not == account_users_path
  end
  
  it "should rate limit voting" do
    5.times { @user.over_rate_limit?.should == false }
    20.times { @user.over_rate_limit? }
    @user.over_rate_limit?.should == true
  end
  
end
