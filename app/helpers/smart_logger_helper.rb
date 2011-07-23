module SmartLoggerHelper
  def log_errors
    Rails.logger.info "#{self.class}!\n #{self.errors.full_messages.join("\n")}"
  end
end