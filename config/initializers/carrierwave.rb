if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => 'digitalaugment',
      :rackspace_api_key  => '6f8c416079c2287e4e5d373ac7eea6e9'
    }
    config.fog_host = "http://c655941.r41.cf2.rackcdn.com"
    config.fog_directory = 'Crumblin-Production'
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => 'digitalaugment',
      :rackspace_api_key  => '6f8c416079c2287e4e5d373ac7eea6e9'
    }
    config.fog_host = "http://c655790.r90.cf2.rackcdn.com"
    config.fog_directory = 'Crumblin-Development'
  end
end
if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end