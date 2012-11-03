###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an application to a community.
###
class CommunityApplication < ActiveRecord::Base
  validates_lengths_from_database
  # Used by mailer to add links to application.
  include Rails.application.routes.url_helpers # FIXME wrap this in a method to get at helpers. See: http://railscasts.com/episodes/132-helpers-outside-views

  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Attribute accessible
###
  attr_accessor :proxy_hash
  attr_accessible :submission_attributes, :character_ids, :proxy_hash

###
# Constants
###
  # The list of vaild status values.
  VALID_STATUSES =  %w(Pending Accepted Rejected Withdrawn Left Removed)

###
# Associations
###
  belongs_to :community
  belongs_to :user_profile
  belongs_to :submission, dependent: :destroy
  has_one :community_profile
  belongs_to :status_changer, class_name: "UserProfile"
  accepts_nested_attributes_for :submission
  has_and_belongs_to_many :characters
  has_many :comments, as: :commentable, dependent: :destroy

###
# Callbacks
###
  before_create :assign_pending_status
  after_create :message_community_admin

###
# Validators
###
  validates :community,  presence: true
  validates :user_profile,  presence: true
  validates :submission,  presence: true
  validates :status,  presence: true,
                    inclusion: { in: VALID_STATUSES, message: "%{value} is not a valid status" },
                    on: :update
  validate :community_and_submission_match
  validate :user_profile_and_submission_match
  validate :user_profile_not_a_member
  validate :characters_are_compatable_with_community

###
# Delegates
###
  delegate :subdomain, to: :community, prefix: true
  delegate :admin_profile_id, to: :community, prefix: true
  delegate :custom_form, to: :submission, allow_nil: true
  delegate :answers, to: :submission, allow_nil: true, prefix: true
  delegate :instructions, to: :custom_form, allow_nil: true, prefix: true
  delegate :thankyou, to: :custom_form, allow_nil: true, prefix: true
  delegate :questions, to: :custom_form, allow_nil: true, prefix: true
  delegate :name, to: :community, prefix: true, allow_nil: true
  delegate :name, to: :custom_form, prefix: true, allow_nil: true
  delegate :display_name, to: :user_profile, prefix: true
  delegate :avatar_url, to: :user_profile, prefix: true

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method accepts this application and does all of the magic to make the applicant a member.
  # [Returns] True if this action was successful, otherwise false.
  ###
  def accept_application(accepted_by_user_profile, character_map = Hash.new) # TODO Make this better!
    return false if self.accepted? or self.applicant_is_a_member?
    error_count = 0
    self.characters.each do |charatcer|
      if character_map[charatcer.id.to_s] == "-1"
        charatcer.errors.add :base, "Character must be assigned to a game or rejected."
        error_count += 1
      end
    end
    return false if error_count > 0 or community.community_profiles.count >= community.max_number_of_users
    if self.update_attributes({status: "Accepted", status_changer: accepted_by_user_profile}, without_protection: true)
      community_profile = self.community.promote_user_profile_to_member(self.user_profile)
      community_profile.update_attributes({community_application_id: self.id},without_protection: true)
      default_url_options[:host] = "#{community.subdomain}.#{ENV['BV_HOST_URL']}"
      message = Message.create_system(subject: "Application Accepted to #{self.community.name}",
                  body: "Your application to [#{self.community.name}](#{root_url(subdomain: self.community_subdomain)}) has been accepted.",
                  to: [self.user_profile_id])

      unless community_profile.nil?
        self.characters.each do |charatcer|
          next unless character_map[charatcer.id.to_s]
          begin
            community_profile.roster_assignments.create!({community_game_id: character_map[charatcer.id.to_s], character: charatcer}, without_protection: true).approve(false)
          rescue ActiveRecord::RecordInvalid => invalid
            logger.error invalid.record.errors
          end
        end
      end
     return true
    end
  end

  ###
  # This method rejects this application.
  # [Returns] True if this action was successful, otherwise false.
  ###
  def reject_application(rejected_by_user_profile)
    return false unless self.is_pending? or self.applicant_is_a_member?
    if self.update_attributes({status: "Rejected", status_changer: rejected_by_user_profile}, without_protection: true)
      default_url_options[:host] = "#{community.subdomain}.#{ENV['BV_HOST_URL']}"
      message = Message.create_system(subject: "Application Rejected",
                            body: "Your application to [#{self.community.name}](#{root_url(subdomain: self.community_subdomain)}) has been rejected.",
                            to: [self.user_profile_id])
    end
  end

  ###
  # This method rejects this application.
  # [Returns] True if this action was successful, otherwise false.
  ###
  def remove_from_community(removed_by_user_profile)
    if removed_by_user_profile.id == self.user_profile.id
      self.update_attributes({status: "Left", status_changer: removed_by_user_profile}, without_protection: true)
    else
      self.update_attributes({status: "Removed", status_changer: removed_by_user_profile}, without_protection: true)
    end
  end

  # This method determines if the applicant is a member of the community.
  def applicant_is_a_member?
    self.user_profile.is_member?(self.community)
  end

  ###
  # This method withdraws this application.
  # [Returns] True if this action was successful, otherwise false.
  ###
  def withdraw
    return false unless self.is_pending?
    self.update_column(:status, "Withdrawn")
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

  # This method returns true if this application's status is left, otherwise false
  def left?
    self.status == "Left"
  end

  # This method returns true if this application's status is left or removed, otherwise false
  def no_longer_a_member?
    self.status == "Left" or self.status == "Removed"
  end

  ###
  # This method preps a new community application, using the user_profile and community_form provided.
  # [Args]
  #   * +user_profile+ -> The user profile you would like to use.
  #   * +custom_form+ -> The custom form you would like to use.
  ###
  def prep(user_profile, custom_form)
    self.user_profile = user_profile
    self.submission = Submission.create!({custom_form: custom_form, user_profile: user_profile}, without_protection: true) unless self.submission
  end

###
# Protected Methods
###
protected

###
# Validator Methods
###
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
    errors.add(:base, "Already a member of the community.") if user_profile.is_member?(community)
  end

  #This method ensures that the character proxies are compatable with the community.
  def characters_are_compatable_with_community
    self.characters.each do |character|
      errors.add(:base, "#{character.name} does not belong to a game that is supported by the community.") unless character.compatable_with_community?(self.community)
    end
  end

###
# Callback Methods
###
  ###
  # _before_create_
  #
  # This method sets the application to pending.
  ###
  def assign_pending_status
    self.status = "Pending"
  end

  ###
  # _after_create_
  #
  # This method send a message to the community admin, if the community settings specify this.
  ###
  def message_community_admin
    if self.community.email_notice_on_application
      default_url_options[:host] = "#{community.subdomain}.#{ENV['BV_HOST_URL']}"
      message = Message.create_system(subject: "Application Submitted to #{self.community.name}",
                            body: "[#{self.user_profile.name}](#{user_profile_url(self.user_profile)}) has submitted [their application](#{community_application_url(self)}) to #{self.community.name}.",
                            to: [self.community.admin_profile_id])
    end
  end
end

# == Schema Information
#
# Table name: community_applications
#
#  id                :integer          not null, primary key
#  community_id      :integer
#  user_profile_id   :integer
#  submission_id     :integer
#  status            :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status_changer_id :integer
#  deleted_at        :datetime
#

