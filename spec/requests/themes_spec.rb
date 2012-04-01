require 'spec_helper'

describe "Themes" do
  
  before do
    @u, @f, @p, @c = create_ufpc
  end
  
  it "should let you create/install/uninstall themes" do
    signin_as @u
    set_subdomain @f.subdomain
    visit account_themes_path
    find('.create-a-theme').click
    fill_in 'theme_name', :with => "Test Theme"
    fill_in 'theme_css', :with => ".topbar .fill { background: #133783; }"
    assert_difference "Theme.count" do
      find('.btn-primary').click
    end
    t = Theme.last
    
    click_on 'Preview'
    page.html.should match("/themes/#{t.id}.css")
    
    visit account_theme_path(t)
    @f.reload.theme.should == nil
    click_on 'Install'
    @f.reload.theme.should == t
    page.html.should match("/themes/#{t.id}.css")
    
    visit account_theme_path(t)
    click_on 'Uninstall'
    @f.reload.theme.should == nil
  end
  
end
