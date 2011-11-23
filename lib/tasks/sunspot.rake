# #lib/tasks/sunspot.rake 
# namespace :sunspot do
#   namespace :solr do
#     desc "indexes searchable models" 
#     task :index => :environment do 
#       #[list your models here].each {|model| Sunspot.index!(model.all)}
#       [Post].each {|model| Sunspot.index(model.all)}
#       Sunspot.commit
#     end
#   end
# end