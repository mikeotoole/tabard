if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['BV_S3_KEY'],
      :aws_secret_access_key  => ENV['BV_S3_SECRET']
    }
    config.fog_directory = 'crumblin'
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['BV_DEV_S3_KEY'],
      :aws_secret_access_key  => ENV['BV_DEV_S3_SECRET']
    }
    config.fog_directory = 'brutalvenom-development'
  end
end
if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end