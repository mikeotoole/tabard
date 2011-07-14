#if Rails.env.production?
#  CarrierWave.configure do |config|
#    config.fog_credentials = {
#      :provider           => 'Rackspace',
#      :rackspace_username => 'digitalaugment',
#      :rackspace_api_key  => '40c425c1543efb4a0f565258f9c6ea35'
#    }
#    config.fog_host = "http://c655941.r41.cf2.rackcdn.com"
#    config.fog_directory = 'Crumblin-Production'
#  end
#else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider           => 'Rackspace',
      :rackspace_username => 'digitalaugment',
      :rackspace_api_key  => '40c425c1543efb4a0f565258f9c6ea35'
    }
    config.fog_host = "http://c655790.r90.cf2.rackcdn.com"
    config.fog_directory = 'Crumblin-Development'
  end
#end
