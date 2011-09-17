class DefaultObjects
  def self.user
    @user ||= DefaultObjects.user_profile.user
  end
  
  def self.user_profile
    @user_profile ||= FactoryGirl.create(:user_profile, :user => FactoryGirl.create(:user))
  end
  
  def self.wow
    @wow ||= FactoryGirl.create(:wow)
  end
  
  def self.swtor
    @swtor ||= FactoryGirl.create(:swtor)
  end
  
  def self.community
    @community ||= FactoryGirl.create(:community)
  end
  
  def self.community_admin
    @community_admin ||= DefaultObjects.community.admin_profile.user
  end
  
  def self.custom_form
    @custom_form ||= FactoryGirl.create(:custom_form)
  end
  
  def self.clean
    @user = nil
    @user_profile = nil
    @wow = nil
    @swtor = nil
    @community = nil
    @custom_form = nil
    @community_admin = nil
  end
end