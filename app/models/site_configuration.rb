###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents the Site Configuration.
###
class SiteConfiguration < ActiveRecord::Base
  validates_lengths_from_database
###
# Attribute accessible
###
  attr_accessible :is_maintenance

###
# Validators
###
  validate :there_can_be_only_one, on: :create

###
# Callbacks
###
  after_save    :expire_site_configuration_first_cache
  after_destroy :expire_site_configuration_first_cache

###
# Public Methods
###
  # Gets the current configuration object. If one does not exist it is created.
  def self.current_configuration
    SiteConfiguration.first_cached
  end

  # Returns true if site is in maintenance mode. False otherwise.
  def self.is_maintenance?
    SiteConfiguration.current_configuration.is_maintenance
  end

###
# Protected Methods
###
protected
  # Gets the first cached site config
  def self.first_cached
    Rails.cache.fetch('SiteConfiguration.first') { SiteConfiguration.first_or_create }
  end

  # clears the cache for the site configuration
  def expire_site_configuration_first_cache
    Rails.cache.delete('SiteConfiguration.first')
  end

###
# Validator Methods
###
  ###
  # _validator_
  #
  # Ensures only one SiteConfiguration object can be created.
  ###
  def there_can_be_only_one
    errors.add(:base, "has already been created") if SiteConfiguration.all.size >= 1
  end
end

# == Schema Information
#
# Table name: site_configurations
#
#  id             :integer          not null, primary key
#  is_maintenance :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

