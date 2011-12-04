if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJONWOSPO4BPWMBQQ',
      :aws_secret_access_key  => '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'
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