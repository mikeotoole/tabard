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
  # List of vaild question styles that require predefined_answers.
  VALID_STYLES_WITH_PA = %w(check_box_question select_box_question radio_buttons_question)
  # List of vaild question styles that don't have predefined_answers.
  VALID_STYLES_WITHOUT_PA = %w(short_answer_question long_answer_question)
  # Used by validators and view to restrict body length
  MAX_BODY_LENGTH = 60
  # Used by validators and view to restrict explanation length
  MAX_EXPLANATION_LENGTH = 100

###
# Attribute accessible
###
  attr_accessible :body, :style, :is_required, :explanation, :type_style, :predefined_answers_attributes

###
# Associations
###
  belongs_to :custom_form
  has_many :answers
  has_many :predefined_answers, :dependent => :destroy, :inverse_of => :question, :autosave => true

###
# Validators
###
  validates :body, :presence => true,
                   :length => { :maximum => MAX_BODY_LENGTH }
  validates :explanation, :length => { :maximum => MAX_EXPLANATION_LENGTH }
  validates :style,  :presence => true,
                    :inclusion => { :in => VALID_STYLES_WITH_PA + VALID_STYLES_WITHOUT_PA, :message => "%{value} is not a valid question style." }

  accepts_nested_attributes_for :predefined_answers, :allow_destroy => true

###
# Callbacks
###
  before_validation :mark_blank_predefined_answers_for_removal

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
        my_clone.explanation = self.explanation
        my_clone.is_required = self.is_required
        my_clone.save(:validate => false)
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
  # This method overrides the clone method so the predefined answers are set to the clone.
  # [Returns] A clone of the select question with the predefined answers.
  ###
  def clone # TODO Mike, Check if this can be removed.
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
end



# == Schema Information
#
# Table name: questions
#
#  id             :integer         not null, primary key
#  body           :text
#  custom_form_id :integer
#  style          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  explanation    :string(255)
#  is_required    :boolean         default(FALSE)
#  deleted_at     :datetime
#

