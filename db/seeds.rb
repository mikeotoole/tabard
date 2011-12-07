if ENV["RAILS_ENV"] != 'test'

  %w{ wow_games swtor_games documents }.each do |part|
    require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
  end
  
  if ENV["RAILS_ENV"] == 'development'  
    %w{ users characters communities roles_permissions discussions pages messages custom_forms}.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
    end
  end

end
