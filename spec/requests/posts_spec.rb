require 'spec_helper'

describe "Posts" do
  
  before do
    @f = create_forum
    @u = create_user
  end
  
  it "should require login to make a new post" do
    visit root_url(:subdomain => @f.subdomain)
    click_on @f.new_post_label
    current_path.should == signin_path
    
    signin_as @u
    
    visit root_url(:subdomain => @f.subdomain)
    click_on @f.new_post_label
    current_path.should == new_post_path
  end
  
  it "should let you make a new post" do
    signin_as @u
    @u.member_of?(@f).should == false
    visit root_url(:subdomain => @f.subdomain)
    click_on @f.new_post_label
    fill_in 'post_title', :with => "Some Title"
    fill_in 'post_text', :with => "Some text"
    assert_difference "Post.count" do
      find('.btn-primary').click
    end
    page.should have_content("Some Title")
    page.should have_content("Some text")
    post = Post.last
    current_path.should == post_path(post)
    @u.member_of?(@f).should == true
  end
  
end
