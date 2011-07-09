class RegistrationApplication < Submission
  belongs_to :discussion

  after_create :generate_discussion
  
  def self.all_new
    RegistrationApplication.all.delete_if {|application| (!application.user_profile.is_applicant)} 
  end
  
  def community_name
    self.site_form.community_name
  end
  
  def applicant_email
    self.user_profile.user.email
  end
  
  def generate_discussion
    self.discussion = Discussion.create(:name => "Application for: "+self.name, :body => "Please feel free to discuss our new applicant.", :discussion_space => DiscussionSpace.registration_application_space)
    logger.error("Oh no registration application not getting discussion") unless self.save
  end
  
  def applicant_role
    self.community.applicant_role
  end
  
end
