require 'spec_helper'

describe "Votes" do
  
  before do
    @u, @f, @p, @c = create_ufpc
    @u2 = create_user
    @u2.update_attribute :superuser, true
  end
  
  it "should let superusers view backend" do
    visit superuser_forums_path
    current_path.should == signin_path
    signin_as @u
    visit superuser_forums_path
    current_path.should == signin_path
    signin_as @u2
    visit superuser_forums_path
    current_path.should == superuser_forums_path
  end

end
