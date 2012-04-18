require 'spec_helper'

describe "Votes" do
  include ActionController::RecordIdentifier
  
  before do
    @u, @f, @p, @c = create_ufpc
    set_subdomain @f.subdomain
    @u2 = create_user
  end
  
  it "should load page for each type of user" do
    # guest
    visit posts_path
    current_path.should == posts_path
    find("#post_#{@p.id} .voting a").click
    current_path.should == signin_path
    
    # admin
    signin_as @u
    visit posts_path
    current_path.should == posts_path
    page.should have_css("#post_#{@p.id} .voting a")

    # visitor
    signin_as @u2
    visit posts_path
    current_path.should == posts_path
    page.should have_css("#post_#{@p.id} .voting a")
  end
  
  def test_clicks voteable, path
    visit path
    selector = "##{dom_id(voteable)}"

    #page.should have_css(selector)
    find("#{selector} .points").text.should == '0'
    voteable.reload.votes['up'].size.should == 0
    voteable.reload.votes['down'].size.should == 0
    
    # upvote
    find("#{selector} .upvote").click
    find("#{selector} .points").text.should == '1'
    page.should have_css("#{selector} .upvote.on")
    visit path
    voteable.reload.votes['up'].size.should == 1
    
    # undo upvote
    find("#{selector} .upvote").click
    find("#{selector} .points").text.should == '0'
    page.should_not have_css("#{selector} .upvote.on")
    visit path
    voteable.reload.votes['up'].size.should == 0
    
    # downvote
    find("#{selector} .downvote").click
    find("#{selector} .points").text.should == '-1'
    page.should have_css("#{selector} .downvote.on")
    visit path
    voteable.reload.votes['down'].size.should == 1
    
    # undo downvote
    find("#{selector} .downvote").click
    visit path
    find("#{selector} .points").text.should == '0'
    page.should_not have_css("#{selector} .downvote.on")
    visit path
    voteable.reload.votes['down'].size.should == 0
    
    # go up from down
    find("#{selector} .downvote").click
    find("#{selector} .upvote").click
    find("#{selector} .points").text.should == '1'
    page.should have_css("#{selector} .upvote.on")
    page.should_not have_css("#{selector} .downvote.on")
    visit path
    voteable.reload.votes['up'].size.should == 1
    voteable.reload.votes['down'].size.should == 0
    
    # go down from up
    find("#{selector} .downvote").click
    find("#{selector} .points").text.should == '-1'
    page.should_not have_css("#{selector} .upvote.on")
    page.should have_css("#{selector} .downvote.on")
    visit path
    voteable.reload.votes['up'].size.should == 0
    voteable.reload.votes['down'].size.should == 1
  end
  
  it "lets you vote on posts index page", :js => true do
    signin_as @u2
    test_clicks @p, posts_path
  end
  
  it "lets you vote on post show page", :js => true do
    signin_as @u2
    visit post_path(@p)
    test_clicks @p, post_path(@p)
  end
  
  it "lets you vote on a comment on the post show page", :js => true do
    signin_as @u2
    visit post_path(@p)
    test_clicks @c, post_path(@p)
  end
  
  it "should reorder comment based on votes", :js => true do
    create_comment :user => @u, :forum => @f, :post => @p, :text => "order testing"
    comments = @p.reload.comments.asc(:lft)
    comments.size.should == 2
    c1 = comments[0]
    c2 = comments[1]
    
    signin_as @u2
    visit post_path(@p)
    find("##{dom_id(c2)} .upvote").click
    visit post_path(@p)
    
    comments = @p.reload.comments.asc(:lft)
    comments[0].should == c2
    comments[1].should == c1
    assert comments[0].ranking > comments[1].ranking
  end
  
end
