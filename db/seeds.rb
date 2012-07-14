unless Rails.env.test?

  %w{ wow_games swtor_games minecraft_games documents themes}.each do |part|
    require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
  end

  if Rails.env.development?
    %w{ users characters communities roles_permissions discussions pages messages custom_forms events}.each do |part|
      require File.expand_path(File.dirname(__FILE__))+"/seeds/#{part}.rb"
    end
  elsif Rails.env.production?
    puts "Seeding 'mike.otoole@digitalaugment.com' super admin"
    AdminUser.create!(email: 'mike.otoole@digitalaugment.com',
                      password: 'DVqaPP7Ai8Q66K',
                      password_confirmation: 'DVqaPP7Ai8Q66K',
                      role: "superadmin")
  end

end
