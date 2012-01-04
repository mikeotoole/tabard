###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a submission to a custom form.
###
class Submission < ActiveRecord::Base
###
# Associations
###
  belongs_to :custom_form
  belongs_to :user_profile

  has_many :answers, :dependent => :destroy
  has_many :questions, :through => :answers
  has_many :form_questions, :through => :custom_form, :class_name => "Question"

  has_one :community, :through => :custom_form

  accepts_nested_attributes_for :answers, :allow_destroy => true

###
# Validators
###
  validates :custom_form, :presence => true
  validates :user_profile, :presence => true
  validate :answered_all_required_questions

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :allow_nil => true
  delegate :name, :to => :custom_form, :prefix => true
  delegate :is_published, :to => :custom_form, :prefix => true
  delegate :instructions, :to => :custom_form, :prefix => true
  delegate :questions, :to => :custom_form, :prefix => true, :allow_nil => true
  delegate :display_name, :to => :user_profile, :prefix => true
  delegate :avatar_url, :to => :user_profile, :prefix => true

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method gets the name of the user who submitted this submission.
  # [Returns] A string that contains the name of the user who submitted this submission.
  ###
  def name
    self.user_profile.name if self.user_profile
  end

  ###
  # This method gets the thankyou message of the site form that this submission belongs to.
  # [Returns] A string that contains the thankyou message of the custom form that this submission belongs to.
  ###
  def thankyou_message
    self.custom_form.thankyou if self.custom_form
  end

  ###
  # This method gets the date that this submission was created.
  # [Returns] A date that contains the creation date of this submission.
  ###
  def submission_date
    self.created_at
  end

  ###
  # This method gets all of the answers for this submission.
  # [Returns] An array that contains all answers for this submission.
  ###
  def all_answers
    self.answers
  end

  ###
  # This method gets all of the unique questions that were answered by this submission.
  # [Returns] A unique array of questions.
  ###
  def all_questions
    self.answers.collect { |answer| answer.question }.uniq
  end

  def answered_all_required_questions
    self.custom_form.questions.each do |question|
      if question.is_required
        self.answers.each do |answer|
          if answer.question_id == question.id
            if answer.body.class == String
              answer.errors.add(:base, "is required to be answered.") if answer.body.blank?
            end
            if answer.body.class == Array
              answer.errors.add(:base, "is required to be answered.") if answer.body.delete_if{|elem| elem.blank?}.join(', ').blank?
            end
          end
        end
      end
    end
  end
end



# == Schema Information
#
# Table name: submissions
#
#  id              :integer         not null, primary key
#  custom_form_id  :integer
#  user_profile_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

