namespace :db do
  task :migrate do 
    if Rails.env.development? or Rails.env.test?
      puts "Running rake parallel:prepare to set up test db"
      system "rake parallel:prepare" # Sets up the test databases
    end
  end
end