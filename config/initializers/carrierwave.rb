if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => 'digitalaugment',
      :rackspace_api_key  => 'b4cb915dbfce8d25deb9d35c5ade15c8'
    }
    config.fog_host = "http://c655941.r41.cf2.rackcdn.com"
    config.fog_directory = 'Crumblin-Production'
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => 'digitalaugment',
      :rackspace_api_key  => 'b4cb915dbfce8d25deb9d35c5ade15c8'
    }
    config.fog_host = "http://c655790.r90.cf2.rackcdn.com"
    config.fog_directory = 'Crumblin-Development'
  end
end
