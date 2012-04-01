require 'spec_helper'

describe "Pages" do
  include ActionController::RecordIdentifier
  
  before do
    @u, @f, @p, @c = create_ufpc
    set_subdomain @f.subdomain
    @u2 = create_user
  end
  
  it "should let admins add and edit pages", :js => true do
    signin_as @u2
    visit account_pages_path
    current_path.should_not == account_pages_path
    
    signin_as @u
    visit account_pages_path
    current_path.should == account_pages_path
    find('.btn-primary').click
    current_path.should == new_account_page_path
    find('#page_name').set("Page1")
    
    find('#text_container').should be_visible
    find('#url_container').should_not be_visible
    find('.url-link').click
    find('#text_container').should_not be_visible
    find('#url_container').should be_visible
    
    find('#page_url').set("http://www.google.com")

    assert_difference "Page.count" do
      find('form .btn-primary').click
      visit account_pages_path
    end

    find('.nav').should have_content("Page1")
    find('table#pages').should have_content("Page1")
    
    # couldn't figure out how to edit the textarea with wysihtml5 iframe https://github.com/jhollingworth/bootstrap-wysihtml5/issues/32
    # @page = @f.pages.first    
    # click_on 'Edit'
    # current_path.should == edit_account_page_path(@page)
    # fill_in 'page_text', :with => "Sample text2"
    # find('form .btn-primary').click
    # 
    # visit account_page_path(@path)
    # page.should have_content("Sample text2")
  end
  
end
