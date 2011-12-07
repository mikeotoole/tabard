if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET']
    }
    config.fog_directory = 'BrutalVenom_Production'
  end
else
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAIETD62Z4ILCUSGFA',
      :aws_secret_access_key  => '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'
    }
    config.fog_directory = 'BrutalVenom_Development'
  end
end
if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end