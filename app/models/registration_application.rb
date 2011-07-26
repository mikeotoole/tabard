class RegistrationApplication < Submission
  belongs_to :discussion

  after_create :generate_discussion, :set_applicant
  
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
  
  def set_applicant
    self.update_attribute(:status, 1)
  end
  
  def set_accepted
    self.update_attribute(:status, 2)
    self.user_profile.user.roles.delete(self.community.applicant_role)
    self.user_profile.user.roles << self.community.member_role
  end
  
  def set_rejected
    self.update_attribute(:status, 4)
    self.user_profile.user.roles.delete(self.community.applicant_role)
  end
  
  def applicant_role
    self.community.applicant_role
  end
  
end
