class Submission < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :site_form
  
  has_many :answers, :dependent => :destroy
  has_many :questions, :through => :answers  
  
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
  
  def name
    self.user_profile.name if self.user_profile
  end
  
  def thankyou_message
    self.site_form.thankyou
  end
  
  def submission_date
    self.created_at
  end
  
  def all_answers
    self.answers
  end
  
  def all_questions
    self.answers.collect { |answer|answer.question }.uniq
  end
  
  def form
    self.site_form
  end
  
end

