class Answer < ActiveRecord::Base
  belongs_to :registration_application
  belongs_to :question
end
