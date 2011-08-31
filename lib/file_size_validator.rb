###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a file size validator.
###
class FileSizeValidator < ActiveModel::EachValidator
  
  # File size validator error messages.
  MESSAGES  = { :is => :wrong_size, :minimum => :size_too_small, :maximum => :size_too_big }.freeze
  # File size validator checks.
  CHECKS    = { :is => :==, :minimum => :>=, :maximum => :<= }.freeze
  # Tokenizer function.
  DEFAULT_TOKENIZER = lambda { |value| value.split(//) }
  # Options reserved for use.
  RESERVED_OPTIONS  = [:minimum, :maximum, :within, :is, :tokenizer, :too_short, :too_long]

###
# This method initalizes this validator.
# [Args]
#   * +options+ -> The options that are used for this validator.
# [Returns] True is the operation succeeded without errors, otherwise false.
# [Raises]
#   * +ArgumentError+ -> if the Range is not specified as a range.
###
  def initialize(options)
    if range = (options.delete(:in) || options.delete(:within))
      raise ArgumentError, ":in and :within must be a Range" unless range.is_a?(Range)
      options[:minimum], options[:maximum] = range.begin, range.end
      options[:maximum] -= 1 if range.exclude_end?
    end

    super
  end

###
# This method validates that the proper parameters has been specified for the validator.
# [Returns] True is the operation succeeded without errors, otherwise false.
# [Raises]
#   * +ArgumentError+ -> if the range is unspecified, or uses a number other than a nonnegative Integer.
###
  def check_validity!
    keys = CHECKS.keys & options.keys

    if keys.empty?
      raise ArgumentError, 'Range unspecified. Specify the :within, :maximum, :minimum, or :is option.'
    end

    keys.each do |key|
      value = options[key]

      unless value.is_a?(Integer) && value >= 0
        raise ArgumentError, ":#{key} must be a nonnegative Integer"
      end
    end
  end

###
# This method validates a carrierwave uploader, ensuring that the file it is uploading is within a specified size.
# [Args]
#   * +object+ -> The object this is to be validated.
#   * +attribute+ -> The attribute that is to be validated.
#   * +value+ -> The value that is to be validated.
# [Returns] True is the operation succeeded without errors, otherwise false.
###
  def validate_each(record, attribute, value)
    raise(ArgumentError, "A CarrierWave::Uploader::Base object was expected") unless value.kind_of? CarrierWave::Uploader::Base

    value = (options[:tokenizer] || DEFAULT_TOKENIZER).call(value) if value.kind_of?(String)

    CHECKS.each do |key, validity_check|
      next unless check_value = options[key]

      value ||= [] if key == :maximum

      value_size = value.size
      next if value_size.send(validity_check, check_value)

      errors_options = options.except(*RESERVED_OPTIONS)
      errors_options[:file_size] = help.number_to_human_size check_value

      default_message = options[MESSAGES[key]]
      errors_options[:message] ||= default_message if default_message

      record.errors.add(attribute, MESSAGES[key], errors_options)
    end
  end

###
# This method gets an instance of an ActionView number helper.
# [Returns] An instance of an ActionView number helper.
###
  def help
    Helper.instance
  end

###
# This is an inner class for getting access to ActionView's number helper.
###
  class Helper
    include Singleton
    include ActionView::Helpers::NumberHelper
  end
end
