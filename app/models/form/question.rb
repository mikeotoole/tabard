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
  VALID_STYLES =  ""

###
# Attribute accessible
###
  attr_accessible :body, :style, :custom_form

###
# Associations
###
  belongs_to :custom_form
  has_many :answers

###
# Validators
###
  validates :body, :presence => true
  validates :style, :presence => true, 
            :inclusion => {:in => VALID_STYLES, :message => "%{value} is not a currently supported single select question style"}
  validates :custom_form, :presence => true

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
    descendants.map{ |descendant| descendant.select_options }.flatten(1)
  end

  ###
  # This method gets the select options for profiles, based on subclasses.
  # [Returns] An alphabetised array of subclasses as strings.
  ###
  def self.select_options
    VALID_STYLES.collect { |style| [ style.scan(/_/).capitalize.join(" "), "#{self.class.to_str}|#{style}" ] }
  end

###
# Instance Methods
###
  ###
  # This method gets the answers for this question from a given submission.
  # [Args]
  #   * +submission_id+ -> An integer that contains the submission id.
  # [Returns] True if the operation succeeded, otherwise false.
  ###
  def answers(submission_id)
    Answer.where(:submission_id => submission_id, :question_id => self.id)
  end
  
  
  ###
  # This method gets the type.
  # [Returns] The type of question.
  ###
  def type_helper
    self.type
  end

  ###
  # This method sets the type.
  # [Args]
  #   * +type+ -> A string that has the type to use.
  # [Returns] True if the operation succeeded, otherwise false.
  ###
  def type_helper=(type)
    self.type = type
  end
end  
  
# == Schema Information
#
# Table name: questions
#
#  id                   :integer         not null, primary key
#  body                 :text
#  custom_form_id       :integer
#  type                 :string(255)
#  style                :string(255)
#  predefined_answer_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

