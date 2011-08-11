=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a registration application.
=end
class RegistrationApplication < Submission
  after_create :set_applicant
  
=begin
  This method gets name of the community that this registration application belongs to.
  [Returns] A string that contains the name of the community this registration application belongs to.
=end
  def community_name
    self.site_form.community_name
  end
  
=begin
  This method gets the email of the user this registration application belongs to.
  [Returns] A string that contains the email of the user this registration application belongs to.
=end
  def applicant_email
    self.user_profile.user_email
  end
  
=begin
  This method sets this registration application to an applicant status.
  [Returns] True is successful, otherwise false.
=end
  def set_applicant
    self.update_attribute(:status, 1)
  end
  
=begin
  This method sets this registration application to an accepted status.
  [Returns] True is successful, otherwise false.
=end
  def set_accepted
    self.update_attribute(:status, 2)
    self.user_profile.user.roles.delete(self.community.applicant_role)
    self.user_profile.user.roles << self.community.member_role
  end
  
=begin
  This method sets this registration application to an rejected status.
  [Returns] True is successful, otherwise false.
=end
  def set_rejected
    self.update_attribute(:status, 4)
    self.user_profile.user.roles.delete(self.community.applicant_role)
  end
  
=begin
  This method gets the applicant role of the community this registration application belongs to.
  [Returns] The applicant role of the community that this registration application belongs to.
=end
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

