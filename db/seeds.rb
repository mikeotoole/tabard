unless Rails.env.test?

  %w{ wow_games swtor_games documents }.each do |part|
    require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
  end

  if Rails.env.development?
    %w{ users characters communities roles_permissions discussions pages messages custom_forms }.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
    end
  elsif Rails.env.production?
    puts "Seeding 'bryan.rogers@digitalaugment.com' super admin"
    AdminUser.create!(:email => 'bryan.rogers@digitalaugment.com', :password => 'DVqaPP7Ai8Q66K', :password_confirmation => 'DVqaPP7Ai8Q66K', :role => "superadmin")
  end

end
