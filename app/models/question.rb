###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a question.
###
class Question < ActiveRecord::Base
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Constants
###
  # The list of vaild game subclass types.
  VALID_TYPES =  %w(SingleSelectQuestion MultiSelectQuestion TextQuestion)

###
# Attribute accessible
###
  attr_accessible :body, :style, :type, :is_required, :explanation, :type_style, :predefined_answers_attributes

###
# Associations
###
  belongs_to :custom_form
  has_many :answers
  has_many :predefined_answers, :dependent => :destroy, :foreign_key => :select_question_id, :inverse_of => :question

###
# Validators
###
  validates :body,  :presence => true,
                    :length => { :maximum => 100 }
  #validates :style, :presence => true
  validates :type,  :presence => true,
                    :inclusion => { :in => VALID_TYPES, :message => "%{value} is not a valid question type." }
  validate :ensure_type_is_not_changed

  accepts_nested_attributes_for :predefined_answers, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true

###
# Callbacks
###
  #before_save :ensure_type_and_style_is_not_changed
  #before_validation :decode_type_style

###
# Delegates
###
  delegate :name, :to => :custom_form, :prefix => true, :allow_nil => true

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
  def self.all_select_options
    descendants.map{ |descendant| descendant.select_options }.flatten(1).compact!
  end

  ###
  # This method gets the select options for profiles, based on subclasses.
  # [Returns] An alphabetised array of subclasses as strings.
  ###
  def self.select_options
    self::VALID_STYLES.collect { |style| [ style.gsub(/_/, ' ').split(' ').each{|word| word.capitalize!}.join(' '), "#{self.to_s}|#{style}" ] } if self::VALID_STYLES
  end

  ###
  # This method ensures that type is not editable.
  ###
  def ensure_type_is_not_changed
    if self.type_changed? and self.persisted?
      self.type = self.type_was
      self.errors.add(:type_style, "can not be changed")
    end
  end

  ###
  # This method attempts to decode and handle changing of a questions type/style
  ###
  def type_style=(new_thing)
    @type_style = new_thing
    return if new_thing == "#{self.type.to_s}|#{self.style}"
    if self.persisted?
      decoded = new_thing.split('|')
      unless self.answers.empty?
        my_clone = self.type.constantize.new
        my_clone.body = self.body
        my_clone.style = self.style
        my_clone.custom_form_id = self.custom_form_id
        my_clone.explanation = self.explanation
        my_clone.is_required = self.is_required
        my_clone.save
        if self.respond_to?(:predefined_answers) and !self.predefined_answers.empty?
          self.predefined_answers.update_all(:select_question_id => my_clone.id)
          self.predefined_answers.clear
        end
        if self.respond_to?(:answers) and !self.answers.empty?
          self.answers.update_all(:question_id => my_clone.id)
          self.answers.clear
        end
        my_clone.destroy
      end
      self.style = decoded[1]
      self.type = decoded[0]
      self.save(:validate => false)
    else
      decoded = new_thing.split('|')
      self.type = decoded[0]
      self.style = decoded[1]
    end
  end

  ###
  # This method returns the type|style.
  ###
  def type_style
    @type_style ||= "#{self.type.to_s}|#{self.style}"
  end

  ###
  # This method creates a new question of the right type and style. If params is not nil the
  # question is initalized with the params hash.
  # [Args]
  #   * +class_style_string+ -> A string with the class name and style separated by a pipe.
  #   * +params+ -> A question attributes hash or nil.
  # [Returns] An intialized question of the right type.
  ###
  def self.new_question(class_style_string, params=nil)
    begin
      class_style_array = class_style_string.split('|')
      @question = class_style_array[0].constantize.new(params)
      @question.style = class_style_array[1]
      @question
    rescue
      nil
    end
  end

###
# Instance Methods
###
  ###
  # This method overrides the clone method so the predefined answers are set to the clone.
  # [Returns] A clone of the select question with the predefined answers.
  ###
  def clone
    question_clone = self.type.constantize.new(self.attributes)
    question_clone.type = self.type
    question_clone.save
    question_clone
  end

  ###
  # This method destroys questions, smartly.
  ###
  def destroy
    run_callbacks :destroy do
      if self.answers.empty?
        self.update_attribute(:deleted_at, Time.now)
      else
        self.update_attribute(:custom_form_id, nil)
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
#  type           :string(255)
#  style          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  explanation    :string(255)
#  is_required    :boolean         default(FALSE)
#  deleted_at     :datetime
#

