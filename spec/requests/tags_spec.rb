require 'spec_helper'

describe "Votes" do
  include ActionController::RecordIdentifier
  
  before do
    @u, @f, @p, @c = create_ufpc
    set_subdomain @f.subdomain
    @u2 = create_user
  end
  
  it "should let admins add tags", :js => true do
    signin_as @u2
    visit account_tags_path
    current_path.should_not == account_tags_path
    
    signin_as @u
    visit account_tags_path
    current_path.should == account_tags_path
    fill_in 'tag_name', :with => "Tag1"
    find('form#new_tag .btn-primary').click
    within 'table.tags' do
      page.should have_content "Tag1"
    end
    fill_in 'tag_name', :with => "Tag2"
    find('form#new_tag .btn-primary').click
    within 'table.tags' do
      page.should have_content "Tag2"
    end
    @f.tags.size.should == 2
    t = @f.tags.asc(:position).first
    t.position.should == 1
    within "##{dom_id(t)}" do
      find(".edit-tag-link").click
      find(".edit").should be_visible
      find(".show").should_not be_visible
      find("#tag_name").set "Tag3"
      click_on 'Save'
      sleep 1
      find(".edit").should_not be_visible
      find(".show").should be_visible
    end
    page.should have_content("Tag3")
    
    within "##{dom_id(t)}" do
      click_on 'Delete'
    end
    page.should_not have_content("Tag3")
    @f.reload.tags.size.should == 1
  end
  
  it "should let you filter by tags" do
    @t1 = create_tag(:forum => @f)
    @t2 = create_tag(:forum => @f)
    @p1 = @p
    @p2 = create_post(:forum => @f)
    @p3 = create_post(:forum => @f)
    
    @p1.tags << [@t1,@t2]
    @p2.tags << [@t1]
    
    visit posts_path
    page.should have_content(@p1.title)
    page.should have_content(@p2.title)
    page.should have_content(@p3.title)
    
    click_on @t1.name
    page.should have_content(@p1.title)
    page.should have_content(@p2.title)
    page.should_not have_content(@p3.title)
    
    click_on @t2.name
    page.should have_content(@p1.title)
    page.should_not have_content(@p2.title)
    page.should_not have_content(@p3.title)
  end
  
end
