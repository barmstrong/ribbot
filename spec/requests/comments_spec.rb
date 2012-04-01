require 'spec_helper'

describe "Comments" do
  
  before do
    @p = create_post
    @f = @p.forum
    @u = @p.user
  end
  
  it "should require login to make a new comment" do    
    visit post_url(@p, :subdomain => @f.subdomain)
    page.should have_css("#new_comment .btn-primary[disabled]")
    fill_in 'comment_text', :with => "Some comment"
    assert_no_difference "Comment.count" do
      find('#new_comment .btn-primary').click
    end
    current_path.should == signin_path
    
    signin_as @u
     
    visit post_url(@p, :subdomain => @f.subdomain)
    fill_in 'comment_text', :with => "Some comment"
    assert_difference "Comment.count" do
      find('#new_comment .btn-primary').click
    end
    page.should have_content("Some comment")
  end
  
  it "should let you reply to a new post", :js => true do
    @c = create_comment :user => @u, :post => @p, :forum => @f
    set_subdomain @f.subdomain
    signin_as @u
    
    visit post_path(@p)
    
    assert_difference "Comment.count" do
      within("#comment_#{@c.id}") do
        page.should have_css(".reply-link")
        page.should_not have_css("#new_comment")
        find(".reply-link").click
        page.should have_css("#new_comment")
        find('#comment_text').set("this is a reply")
        find("form .btn-primary").click
      end
      page.should have_content("this is a reply")
      visit post_path(@p)
      page.should have_content("this is a reply")
    end
    c = Comment.last
    c.parent.should == @c
    c.forum.should == @f
    c.user.should == @u
  end
  
  it "should not show deleted comments on page" do
    text = "Delete me!"
    @c = create_comment :user => @u, :post => @p, :forum => @f, :text => text
    visit post_url(@p, :subdomain => @f.subdomain)
    page.should have_content(text)
    @c.update_attribute :deleted, true
    visit post_url(@p, :subdomain => @f.subdomain)
    page.should_not have_content(text)
  end
  
end
