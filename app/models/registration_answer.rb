class RegistrationAnswer < Answer
  belongs_to :question
  belongs_to :registration_application
end
