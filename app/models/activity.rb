###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an actvity.
###
class Activity < ActiveRecord::Base
  validates_lengths_from_database
###
# Constants
###
  # The default number of items self.activities() should return.
  DEFAULT_MAX_ITEMS = 10

###
# Attribute accessible
###
  attr_accessible :target_type, :target_id, :target, :action, :user_profile, :user_profile_id, :community

###
# Associations
###
  belongs_to :user_profile, inverse_of: :activities
  belongs_to :community, inverse_of: :activities
  belongs_to :target, polymorphic: true

###
# Delegates
###
  delegate :name, to: :community, prefix: true
  delegate :subdomain, to: :community, prefix: true
  delegate :display_name, to: :user_profile, prefix: true

###
# Validators
###
  validates :user_profile, presence: true
  validates :target, presence: true
  validates :action, presence: true

###
# Scopes
###
  scope :ordered, order: "updated_at DESC"

  ###
  # Used to retrive an array of activities.
  # [Args]
  #   * +activity+ An optinal hash containg :user_profile_id and/or :community_id. For example: {user_profile_id: 1, community_id: 4}
  #   * +updated+ An optinal hash containg :since and/or :before. These are both dates.
  #                   If only since is given activities that occurred after that date will be returned.
  #                     For example: {since: 2.day.ago} will return all activiies that happend from now till 2 days ago.
  #                   If only before is given activities that occurred before that date will be returned.
  #                   If both since and before is given activities that occurred between those dates will be returned.
  #   * +max_items+ An optinal number of items to return.
  # [Returns] An array containg both activites and comments in decending order.
  ###
  def self.activities(activity=nil, updated=nil, max_items=DEFAULT_MAX_ITEMS)
    max_items = max_items.to_i
    max_items = DEFAULT_MAX_ITEMS unless max_items > 0
    max_items = 50 unless max_items < 50

    if updated and updated[:since] and updated[:before]
      since = Time.zone.parse(updated[:since]).utc
      before = Time.zone.parse(updated[:before]).utc
      activities = Activity.ordered.where(activity).where('updated_at < ? AND updated_at > ?', since, before).limit(max_items.to_i)
    elsif updated and updated[:since]
      since = Time.zone.parse(updated[:since]).utc
      activities = Activity.ordered.where(activity).where('updated_at > ?', since).limit(max_items.to_i)
    elsif updated and updated[:before]
      before = Time.zone.parse(updated[:before]).utc
      activities = Activity.ordered.where(activity).where('updated_at < ?', before).limit(max_items.to_i)
    else
      activities = Activity.ordered.where(activity).limit(max_items.to_i)
    end

    return activities
  end
end





# == Schema Information
#
# Table name: activities
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  community_id    :integer
#  target_type     :string(255)
#  target_id       :integer
#  action          :string(255)
#  deleted_at      :datetime
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

