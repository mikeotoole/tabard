class RegistrationApplication < Submission
  belongs_to :discussion
  
  after_create :generate_discussion
  
  def status
    self.user_profile.status_string
  end
  
  def applicant_email
    self.user_profile.user.email
  end
  
  def generate_discussion
    self.discussion = Discussion.create(:name => "Application for: "+self.name, :body => "Please feel free to discuss our new applicant.", :discussion_space => DiscussionSpace.registration_application_space)
    logger.error("Oh no registration application not getting discussion") unless self.save
  end
  
end
