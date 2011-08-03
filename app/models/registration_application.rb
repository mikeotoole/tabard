class RegistrationApplication < Submission
  after_create :set_applicant
  
  def self.all_new
    RegistrationApplication.all.delete_if {|application| (!application.user_profile.is_applicant)} 
  end
  
  def community_name
    self.site_form.community_name
  end
  
  def applicant_email
    self.user_profile.user.email
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

