###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a question.
###
class Question < ActiveRecord::Base
###
# Constants
###
  # The list of vaild game subclass types.
  VALID_TYPES =  %w(SingleSelectQuestion MultiSelectQuestion TextQuestion)

###
# Attribute accessible
###
  attr_accessible :body, :style, :custom_form_id

###
# Associations
###
  belongs_to :custom_form
  has_many :answers

###
# Validators
###
  validates :body,  :presence => true
  validates :style, :presence => true
  validates :type,  :presence => true,
                    :inclusion => { :in => VALID_TYPES, :message => "%{value} is not a valid question type." }

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
  # This method overrides the clone method so the predefined answers are set to the clone.
  # [Returns] A clone of the select question with the predefined answers.
  ###
  def clone
    question_clone = self.type.constantize.new(self.attributes)
    question_clone.type = self.type
    question_clone.save
    question_clone
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
#  required       :boolean         default(FALSE)
#
