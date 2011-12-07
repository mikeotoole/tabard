namespace :seed do
  desc "Seeds all data"
  task :all => [:users, :communities] do
    puts "All data seeded!"
  end
  
  desc "Seeds Users"
  task :users do
    puts "Seeding users.."
    require File.expand_path(File.dirname(__FILE__) + "/../../db/seeds.rb")
  end
  
  desc "Seeds Communities"
  task :communities do
    puts "Seeding users.."
    
  end
end