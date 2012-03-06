###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a site form.
###
class CustomForm < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  # Used by validators and view to restrict name length
  MAX_NAME_LENGTH = 30
  # Used by validators and view to restrict instructions length
  MAX_INSTRUCTIONS_LENGTH = 500
  # Used by validators and view to restrict thank you length
  MAX_THANKYOU_LENGTH = 255

###
# Attribute accessible
###
  attr_accessible :name, :instructions, :thankyou, :is_published, :questions_attributes

###
# Associations
###
  has_many :submissions, :dependent => :destroy
  has_many :questions, :dependent => :destroy, :autosave => true, :order => 'id ASC'
  accepts_nested_attributes_for :questions, :allow_destroy => true

  has_many :submissions, :dependent => :destroy
  belongs_to :community

###
# Validators
###
  validates :name,  :presence => true,
                    :length => { :maximum => MAX_NAME_LENGTH }
  validates :instructions, :length => { :maximum => MAX_INSTRUCTIONS_LENGTH }
  validates :thankyou, :presence => true,
                       :length => { :maximum => MAX_THANKYOU_LENGTH }
  validates :community, :presence => true
  validate :cant_unpublish_application_form
  validate :question_have_predefined_answers

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :allow_nil => true
  delegate :name, :to => :community, :prefix => true, :allow_nil => true

###
# Callbacks
###
  after_create :apply_default_permissions

###
# Scopes
###
  scope :published, where(:is_published => true)

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method gets the name of the community that this form belongs to.
  # [Returns] A string that contains the display name of the community that this form belongs to, otherwise it contains the empty string.
  ###
  def community_name
    return self.community.name if self.community
    ""
  end

  ###
  # This method checks to see if this custom form is an application form for a community.
  # [Returns] True is this form is the community application form, otherwise false.
  ###
  def application_form?
    self.community.community_application_form == self
  end

  # This method applys default permissions when this is created.
  def apply_default_permissions
    self.community.apply_default_permissions(self)
  end

###
# Protected Methods
###
protected

###
# Validator Methods
###
  ###
  # This method validates that the selected game is valid for the community.
  ###
  def cant_unpublish_application_form
    return unless not self.is_published and self.community and self.community.community_application_form == self
    self.errors.add(:is_published, "must be true for community application form.")
  end

  # This method checks to see if questions that require predefined answers have at least one
  def question_have_predefined_answers
    self.questions.each do |question|
      if Question::VALID_STYLES_WITH_PA.include?(question.style)
        has_at_least_one = false
        question.predefined_answers.each do |panswer|
          if not panswer.marked_for_destruction?
            has_at_least_one = true
            break
          end
        end
        unless has_at_least_one
          errors.add(:base, "All questions that can have predefined answers require at least one answer.")
          question.errors.add(:base, "requires at least one predefined answer.")
        end
      end
    end
  end
end



# == Schema Information
#
# Table name: custom_forms
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  instructions :text
#  thankyou     :string(255)
#  is_published :boolean         default(FALSE)
#  community_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  deleted_at   :datetime
#

