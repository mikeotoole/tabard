###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a submission to a custom form.
###
class Submission < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :custom_form, :user_profile, :answers

###
# Associations
###
  belongs_to :custom_form
  belongs_to :user_profile

  has_many :answers, :dependent => :destroy
  has_many :questions, :through => :answers

  has_one :community, :through => :custom_form

  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:body].blank? }, :allow_destroy => true

###
# Validators
###
  validates :custom_form, :presence => true
  validates :user_profile, :presence => true
# TODO Mike, Should this validate that there is an answer to each question?

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # 
  ###
  def contains_predefined_answer(panswer)
    self.answers.each do |answer|
      if answer.question_id == panswer.question_id and answer.content == panswer.content
        answer.id = -answer.question_id unless answer.id
        return answer
      end
    end
    nil
  end

  ###
  # 
  ###
  def contains_predefined_answer_from_collection(panswer_collection)
    panswer_collection.each do |panswer|
      return self.contains_predefined_answer(panswer) if self.contains_predefined_answer(panswer) != nil
    end
    nil
  end

  ###
  # 
  ###
  def contains_answer_to_question(question)
    self.answers.each do |answer|
      if answer.question_id == question.id
        answer.id = -answer.question_id unless answer.id
        return answer
      end
    end
    nil
  end

  ###
  # This method gets the name of the user who submitted this submission.
  # [Returns] A string that contains the name of the user who submitted this submission.
  ###
  def name
    self.user_profile.name if self.user_profile
  end

  ###
  # This method gets the thankyou message of the site form that this submission belongs to.
  # [Returns] A string that contains the thankyou message of the site form that this submission belongs to.
  ###
  def thankyou_message
    self.site_form.thankyou if self.site_form
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
    self.answers.collect { |answer|answer.question }.uniq
  end

  ###
  # This method gets the form that this submission belongs to.
  # [Returns] The site form that this submission belongs to.
  ###
  def form
    self.site_form
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

