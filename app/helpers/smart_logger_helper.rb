=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This helper module is for logging errors on models. This is for metrics capturing to see if users are having issues with certain validators.
=end
module SmartLoggerHelper
  def log_errors
    Rails.logger.info "#{self.class}!\n #{self.errors.full_messages.join("\n")}"
  end
end
