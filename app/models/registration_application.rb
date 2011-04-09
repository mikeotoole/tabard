class RegistrationApplication < Submission
  belongs_to :discussion

  after_create :generate_discussion
  
  def self.all_new
    RegistrationApplication.all.delete_if {|application| (!application.user_profile.is_applicant)} 
  end
  
  def status_string
    self.user_profile.status_string
  end
  
  def status
    self.user_profile.status
  end
  
  def applicant_email
    self.user_profile.user.email
  end
  
  def generate_discussion
    self.discussion = Discussion.create(:name => "Application for: "+self.name, :body => "Please feel free to discuss our new applicant.", :discussion_space => DiscussionSpace.registration_application_space)
    logger.error("Oh no registration application not getting discussion") unless self.save
  end
  
end
