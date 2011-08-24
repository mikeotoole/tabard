=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a submission to a site form.
=end
class Submission < ActiveRecord::Base
  #attr_accessible :user_profile, :comments, :site_form, :status, :answers

  belongs_to :user_profile
  belongs_to :site_form

  has_many :comments, :as => :commentable
  has_many :answers, :dependent => :destroy
  has_many :questions, :through => :answers

  has_one :community, :through => :site_form

  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true


  def contains_predefined_answer(panswer)
    self.answers.each do |answer|
      if answer.question_id == panswer.question_id and answer.content == panswer.content
        answer.id = -answer.question_id unless answer.id
        return answer
      end
    end
    nil
  end

  def contains_predefined_answer_from_collection(panswer_collection)
    panswer_collection.each do |panswer|
      return self.contains_predefined_answer(panswer) if self.contains_predefined_answer(panswer) != nil
    end
    nil
  end

  def contains_answer_to_question(question)
    self.answers.each do |answer|
      if answer.question_id == question.id
        answer.id = -answer.question_id unless answer.id
        return answer
      end
    end
    nil
  end

=begin
  This method gets the name of the user who submitted this submission.
  [Returns] A string that contains the name of the user who submitted this submission.
=end
  def name
    self.user_profile.name if self.user_profile
  end

=begin
  This method gets the thankyou message of the site form that this submission belongs to.
  [Returns] A string that contains the thankyou message of the site form that this submission belongs to.
=end
  def thankyou_message
    self.site_form.thankyou
  end

=begin
  This method gets the date that this submission was created.
  [Returns] A date that contains the creation date of this submission.
=end
  def submission_date
    self.created_at
  end

=begin
  This method gets all of the answers for this submission.
  [Returns] An array that contains all answers for this submission.
=end
  def all_answers
    self.answers
  end

=begin
  This method gets all of the unique questions that were answered by this submission.
  [Returns] A unique array of questions.
=end
  def all_questions
    self.answers.collect { |answer|answer.question }.uniq
  end

=begin
  This method gets the form that this submission belongs to.
  [Returns] The site form that this submission belongs to.
=end
  def form
    self.site_form
  end

=begin
  This method gets the status of the submission as a human readable string.
  [Returns] A string that contains the human readable status of this submission.
=end
  def status_string
    if is_applicant
      "Applicant"
    elsif is_accepted
      "Accepted"
    elsif is_inactive
      "Deactivated User"
    elsif is_rejected
      "Rejected"
    else
      "Unknown"
    end
  end

=begin
  This method determines if the status of this submission is applicant.
  [Returns] True if the status of this submission is applicant, otherwise false.
=end
  def is_applicant
    if self.status == 1
      return true
    else
      return false
    end
  end

=begin
  This method determines if the status of this submission is accepted.
  [Returns] True if the status of this submission is accepted, otherwise false.
=end
  def is_accepted
    if self.status == 2
      return true
    else
      return false
    end
  end

=begin
  This method determines if the status of this submission is inactive.
  [Returns] True if the status of this submission is inactive, otherwise false.
=end
  def is_inactive
    if self.status == 3
      return true
    else
      return false
    end
  end

=begin
  This method determines if the status of this submission is rejected.
  [Returns] True if the status of this submission is rejected, otherwise false.
=end
  def is_rejected
    if self.status == 4
      return true
    else
      return false
    end
  end

=begin
  This method sets the status of this submission to applicant.
  [Returns] True if the operation is successful, otherwise false.
=end
  def set_applicant
    self.update_attributes(:status => 1)
  end

=begin
  This method sets the status of this submission to accepted. This can only happen if the current status is applicant.
  [Returns] True if the operation is successful, otherwise false.
=end
  def set_accepted
    self.update_attributes(:status => 2) if self.status == 1
  end

=begin
  This method sets the status of this submission to inactive.
  [Returns] True if the operation is successful, otherwise false.
=end
  def set_inactive
    self.update_attributes(:status => 3)
  end

=begin
  This method sets the status of this submission to rejected. This can only happen if the current status is applicant.
  [Returns] True if the operation is successful, otherwise false.
=end
  def set_rejected
    self.update_attributes(:status => 4) if self.status == 1
  end
end


# == Schema Information
#
# Table name: submissions
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  site_form_id    :integer
#  type            :string(255)
#  status          :integer
#

