###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an application to a community.
###
class CommunityApplication < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :submission_attributes, :character_proxy_ids
###
# Constants
###
  # The list of vaild status values.
  VALID_STATUSES =  %w(Pending Accepted Rejected Withdrawn)

###
# Associations
###
  belongs_to :community
  belongs_to :user_profile
  belongs_to :submission
  accepts_nested_attributes_for :submission
  has_and_belongs_to_many :character_proxies
  has_many :comments, :as => :commentable, :dependent => :destroy

###
# Callbacks
###
  before_create :assign_pending_status
  after_create :message_community_admin

###
# Validators
###
  validates :community,  :presence => true
  validates :user_profile,  :presence => true
  validates :submission,  :presence => true
  validates :status,  :presence => true,
                    :inclusion => { :in => VALID_STATUSES, :message => "%{value} is not a valid status" },
                    :on => :update
  validate :community_and_submission_match
  validate :user_profile_and_submission_match
  validate :user_profile_not_a_member

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :prefix => true
  delegate :custom_form, :to => :submission, :allow_nil => true
  delegate :answers, :to => :submission, :allow_nil => true, :prefix => true
  delegate :instructions, :to => :custom_form, :allow_nil => true, :prefix => true
  delegate :thankyou, :to => :custom_form, :allow_nil => true, :prefix => true
  delegate :questions, :to => :custom_form, :allow_nil => true, :prefix => true
  delegate :name, :to => :custom_form, :prefix => true, :allow_nil => true
  delegate :display_name, :to => :user_profile, :prefix => true
  delegate :avatar_url, :to => :user_profile, :prefix => true

  ###
  # _before_create_
  #
  # This method sets the application to pending.
  ###
  def assign_pending_status
    self.status = "Pending"
  end

  ###
  # _before_create_
  #
  # This method send a message to the community admin, if the community settings specify this.
  ###
  def message_community_admin
    # TODO Doug/Bryan, Determine what message content should be.
    if self.community.email_notice_on_application
      message = Message.new(:subject => "Application Submitted for #{self.community.name}", :body => "#{self.user_profile.name} has submitted an application.", :to => [self.community.admin_profile_id])
      message.is_system_sent = true
      message.save
    end
  end

  ###
  # This method accepts this application and does all of the magic to make the applicant a member.
  # [Returns] True if this action was successful, otherwise false.
  ###
  def accept_application
    return false unless self.is_pending?
    self.update_attribute(:status, "Accepted")
    community_profile = self.community.promote_user_profile_to_member(self.user_profile)
    # TODO Doug/Bryan, Determine what message content should be.
    message = Message.new(:subject => "Application Accepted", :body => "Your application to #{self.community.name} has been accepted.", :to => [self.user_profile.id])
    message.is_system_sent = true
    message.save
    self.character_proxies.each do |proxy|
      if self.community.is_protected_roster
        RosterAssignment.create(:community_profile => community_profile, :character_proxy => proxy).approve
      else
        RosterAssignment.create(:community_profile => community_profile, :character_proxy => proxy)
      end
    end
  end

  ###
  # This method rejects this application.
  # [Returns] True if this action was successful, otherwise false.
  ###
  def reject_application
    return false unless self.is_pending?
    self.update_attribute(:status, "Rejected")
    # TODO Doug/Bryan, Determine what message content should be.
    message = Message.new(:subject => "Application Rejected", :body => "Your application to #{self.community.name} has been rejected.", :to => [self.user_profile.id])
    message.is_system_sent = true
    message.save
  end

  ###
  # This method withdraws this application.
  # [Returns] True if this action was successful, otherwise false.
  ###
  def withdraw
    return false unless self.is_pending?
    self.update_attribute(:status, "Withdrawn")
  end

  # This method returns true if this application's status is pending, otherwise false
  def is_pending?
    self.status == "Pending"
  end

  # This method returns true if this application's status is pending, otherwise false
  def withdrawn?
    self.status == "Withdrawn"
  end

  # This method returns true if this application's status is accepted, otherwise false
  def accepted?
    self.status == "Accepted"
  end

  # This method returns true if this application's status is rejected, otherwise false
  def rejected?
    self.status == "Rejected"
  end

  ###
  # This method preps a new community application, using the user_profile and community_form provided.
  # [Args]
  #   * +user_profile+ -> The user profile you would like to use.
  #   * +custom_form+ -> The custom form you would like to use.
  ###
  def prep(user_profile, custom_form)
    self.user_profile = user_profile
    self.submission = Submission.create(:custom_form => custom_form, :user_profile => user_profile) unless self.submission
  end

protected
  # This method ensures that the community application for is the custom form for the submission
  def community_and_submission_match
    return unless submission and community
    errors.add(:base, "The submission does not match the community's application form.") unless submission.custom_form == community.community_application_form
  end
  # This method ensures that the community application for is the custom form for the submission
  def user_profile_and_submission_match
    return unless submission and user_profile
    errors.add(:base, "The submission does not match this user profile.") unless submission.user_profile == user_profile
  end
  # This method ensures that the community application for is the custom form for the submission
  def user_profile_not_a_member
    return unless community and user_profile
    errors.add(:base, "This user_profile is already a member of the community.") if user_profile.is_member?(community)
  end
end

# == Schema Information
#
# Table name: community_applications
#
#  id              :integer         not null, primary key
#  community_id    :integer
#  user_profile_id :integer
#  submission_id   :integer
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

