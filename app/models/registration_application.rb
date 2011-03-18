class RegistrationApplication < Submission
  belongs_to :discussion
  
  def status_string
    self.user_profile.status_string
  end
  
  def status
    self.user_profile.status
  end
  
  def applicant_email
    self.user_profile.user.email
  end
  
end
