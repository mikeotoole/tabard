class RegistrationApplication < Submission
  belongs_to :discussion
  
  def status
    self.user_profile.status_string
  end
  
  def applicant_email
    self.user_profile.user.email
  end
  
end
