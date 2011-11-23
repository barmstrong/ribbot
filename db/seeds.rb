# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  require File.expand_path('../../spec/support/factories.rb', __FILE__)
  DatabaseCleaner.clean
  
  u1, f1 = create_user_with_forum({:email => 'user1@example.com', :name => "Brian Armstrong"}, {:subdomain => 'support', :name => "Ribbot Support"})
  u1.update_attribute :superuser, true
  u2, f2 = create_user_with_forum({:email => 'user2@example.com', :name => "Bubba Gump"}, {:subdomain => 'test'})
  
  p1 = create_post :forum => f1, :user => u1, :title => "My first post", :text => "here is some text"
  create_comment :forum => f1, :user => u1, :post => p1, :text => "epic comment"
  create_comment :forum => f1, :user => u2, :post => p1, :text => "just had to chime in"
  
  p2 = create_post :forum => f1, :user => u2, :title => "Another post!", :text => "here is some more text"
  3.times do |i|
    create_comment :forum => f1, :user => u2, :post => p2, :text => "comment number #{i+1}"
  end
  
  p3 = create_post :forum => f1, :user => u1, :title => "URL post", :url => "http://www.google.com"
  
  t1 = f1.tags.create(:name => "New")
  t2 = f1.tags.create(:name => "Pending")
  t3 = f1.tags.create(:name => "Complete")
  
  p1.tags << [t1]
  p2.tags << [t1,t2]
end