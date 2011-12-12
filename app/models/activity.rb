###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an actvity.
###
class Activity < ActiveRecord::Base

  DEFAULT_MAX_ITEMS = 10
###
# Attribute accessible
###
  attr_accessible :target_type, :target_id, :target, :action, :user_profile, :community

###
# Associations
###
  belongs_to :user_profile
  belongs_to :community
  belongs_to :target, :polymorphic => true

###
# Validators
###
  validates :user_profile, :presence => true
  validates :target, :presence => true
  validates :action, :presence => true
  
  scope :ordered, :order => "updated_at DESC"
  
  
  def self.activities(activity=nil, updated=nil, max_items=DEFAULT_MAX_ITEMS)
    max_items = DEFAULT_MAX_ITEMS unless max_items
     
    if updated and updated[:since] and updated[:before]
      @activities = Activity.ordered.where(activity).where('updated_at < :since AND updated_at > :before', updated).first(max_items.to_i)
      @comments = Comment.not_deleted.ordered.where(activity).where('updated_at < :since AND updated_at > :before', updated).first(max_items.to_i)
    elsif updated and updated[:since]
      @activities = Activity.ordered.where(activity).where('updated_at > :since', updated).first(max_items.to_i)
      @comments = Comment.not_deleted.ordered.where(activity).where('updated_at > :since', updated).first(max_items.to_i)
    elsif updated and updated[:before]
      @activities = Activity.ordered.where(activity).where('updated_at < :before', updated).first(max_items.to_i)
      @comments = Comment.not_deleted.ordered.where(activity).where('updated_at < :before', updated).first(max_items.to_i)
    else
      @activities = Activity.ordered.where(activity).first(max_items.to_i)
      @comments = Comment.not_deleted.ordered.where(activity).first(max_items.to_i)
    end
    
    @items = @activities + @comments
    @items.sort!{|item1, item2| item2.updated_at <=> item1.updated_at}
    @items[0..max_items.to_i-1]
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
#  created_at      :datetime
#

