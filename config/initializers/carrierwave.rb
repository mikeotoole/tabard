CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider           => 'Rackspace',
    :rackspace_username => 'digitalaugment',
    :rackspace_api_key  => 'b4cb915dbfce8d25deb9d35c5ade15c8'
  }
  config.fog_host = "http://c655790.r90.cf2.rackcdn.com"
  config.fog_directory = 'name_of_directory'
end
