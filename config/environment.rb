# Override Profanalyzer default list with ours. This will make is so it is only loaded once.
if ENV["RAILS_ENV"] != 'test'
  class Profanalyzer
    Profanalyzer.send(:remove_const, "FULL") if Profanalyzer.const_defined?("FULL")
    Profanalyzer.const_set("FULL", YAML.load_file("config/name_lists/profanity_list.yml"))
  end
end

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
DaBvRails::Application.initialize!