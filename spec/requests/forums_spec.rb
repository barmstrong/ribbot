require 'spec_helper'

describe "Forums" do
  it "should let you create a new one" do
    visit new_forum_path
    current_path.should == signin_path
    u = create_user
    signin_as u
    visit new_forum_path
    current_path.should == new_forum_path
    fill_in 'forum_subdomain', :with => "testing1"
    assert_difference "Forum.count" do
      click_on 'Create Forum'
    end
    page.should have_content("Welcome")
    u.admin_of?(Forum.last).should == true
    visit forums_path
    page.should have_content("Testing1")
  end
  
  it "should allow you to change submission types", :js => true do
    u, f = create_user_with_forum
    set_subdomain f.subdomain
    signin_as u
    
    f.post_options.should == Forum::POST_OPTIONS[:text_or_url]
    visit new_post_path
    page.should have_css('#post_text')
    page.should have_css('#post_url')
    find('#post_text').should be_visible
    find('#post_url').should_not be_visible
    find('.url-link').click
    find('#post_text').should_not be_visible
    find('#post_url').should be_visible
    
    f.update_attribute :post_options, Forum::POST_OPTIONS[:url_or_text]
    visit new_post_path
    page.should have_css('#post_text')
    page.should have_css('#post_url')
    find('#post_text').should_not be_visible
    find('#post_url').should be_visible
    find('.text-link').click
    find('#post_text').should be_visible
    find('#post_url').should_not be_visible
    
    f.update_attribute :post_options, Forum::POST_OPTIONS[:url_only]
    visit new_post_path
    page.should_not have_css('#post_text')
    page.should have_css('#post_url')
    find('#post_url').should be_visible
    
    f.update_attribute :post_options, Forum::POST_OPTIONS[:text_only]
    visit new_post_path
    page.should have_css('#post_text')
    page.should_not have_css('#post_url')
    find('#post_text').should be_visible
  end
  
  it "should only let owner delete forum" do
    u, f = create_user_with_forum
    signin_as u
    set_subdomain f.subdomain
    p = u.participations.first
    
    p.update_attribute :level, Participation::ADMIN
    visit account_ownership_path
    assert_no_difference "Forum.count" do
      find('.delete-forum').click
    end
    
    p.update_attribute :level, Participation::OWNER
    visit account_ownership_path
    assert_difference "Forum.count", -1 do
      find('.delete-forum').click
    end
    visit forums_path
    
  end
end
