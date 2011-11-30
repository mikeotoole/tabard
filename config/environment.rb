class Profanalyzer
  Profanalyzer.send(:remove_const, "FULL")
  Profanalyzer.const_set("FULL", YAML.load_file("config/profanity_list.yml"))
end

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
DaBvRails::Application.initialize!