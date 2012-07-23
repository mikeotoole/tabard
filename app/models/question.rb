###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a question.
###
class Question < ActiveRecord::Base
  validates_lengths_from_database except: [:body, :explanation]
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  # List of vaild question styles that require predefined_answers.
  VALID_STYLES_WITH_PA = %w(check_box_question select_box_question radio_buttons_question)
  # List of vaild question styles that don't have predefined_answers.
  VALID_STYLES_WITHOUT_PA = %w(short_answer_question long_answer_question)
  # List of all valid styles
  VALID_STYLES = VALID_STYLES_WITH_PA + VALID_STYLES_WITHOUT_PA
  # Used by validators and view to restrict body length
  MAX_BODY_LENGTH = 60
  # Used by validators and view to restrict explanation length
  MAX_EXPLANATION_LENGTH = 100

###
# Attribute accessible
###
  attr_accessible :body, :style, :is_required, :explanation, :position, :predefined_answers_attributes

###
# Associations
###
  belongs_to :custom_form
  has_many :predefined_answers, dependent: :destroy, inverse_of: :question, autosave: true, order: 'id ASC'

###
# Validators
###
  validates :body, presence: true,
                   length: { maximum: MAX_BODY_LENGTH }
  validates :explanation, length: { maximum: MAX_EXPLANATION_LENGTH }
  validates :style,  presence: true,
                    inclusion: { in: VALID_STYLES, message: "%{value} is not a valid question style." }
  validate :predefined_answers_are_not_too_similar

  accepts_nested_attributes_for :predefined_answers, allow_destroy: true

###
# Callbacks
###
  before_validation :mark_blank_predefined_answers_for_removal
  before_save :remove_predefined_answers_if_needed

###
# Delegates
###
  delegate :name, to: :custom_form, prefix: true, allow_nil: true

###
# Public Methods
###

###
# Class Methods
###
  ###
  # This method gets the select options for profiles, based on subclasses.
  # [Returns] An alphabetised array of subclasses as strings.
  ###
  def self.select_options
    [['short_answer_question','Short Answer'],['long_answer_question','Long Answer'],['check_box_question','Checkboxes'],['radio_buttons_question','Radio Buttons'],['select_box_question','Dropdown']]
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_validation_
  #
  # This will remove any blank predefined answers. If the last was removed an error is added.
  ###
  def mark_blank_predefined_answers_for_removal
    predefined_answers.each do |panswer|
      if panswer.body.blank?
        if self.predefined_answers.reject{|answer| answer.marked_for_destruction?}.count >= 1
          panswer.mark_for_destruction
        else
          errors.add(:base, "requires at least one predefined answer.")
        end
      end
    end
  end

  ###
  # _before_save_
  #
  # This will remove predefined answers if style does not have use them.
  ###
  def remove_predefined_answers_if_needed
    if VALID_STYLES_WITHOUT_PA.include?(self.style)
      self.predefined_answers.clear
    end
  end
  # This makes sure the predefined answers are not too similar.
  def predefined_answers_are_not_too_similar
    self.predefined_answers.each_with_index do |pa, pa_i|
      self.predefined_answers.each_with_index do |po, po_i|
        if pa_i != po_i and pa.body_as_id == po.body_as_id
          pa.errors.add(:body, "is too similar to another predefined answer.")
        end
      end
    end
  end
end







# == Schema Information
#
# Table name: questions
#
#  id             :integer         not null, primary key
#  body           :text
#  custom_form_id :integer
#  style          :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  explanation    :string(255)
#  is_required    :boolean         default(FALSE)
#  deleted_at     :datetime
#  position       :integer         default(0)
#

