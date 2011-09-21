class DefaultObjects
  def self.user
    @user ||= DefaultObjects.user_profile.user
  end
  
  def self.user_profile
    @user_profile ||= FactoryGirl.create(:user_profile, :user => FactoryGirl.create(:user))
    DefaultObjects.community.promote_user_profile_to_member(@user_profile)
    @user_profile
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
  
  def self.discussion_space
    @discussion_space ||= FactoryGirl.create(:discussion_space)
  end
  
  def self.discussion
    @discussion ||= FactoryGirl.create(:discussion, :discussion_space_id => DefaultObjects.discussion_space.id)
  end
  
  def self.clean
    @user = nil
    @user_profile = nil
    @wow = nil
    @swtor = nil
    @community = nil
    @community_admin = nil
    @custom_form = nil
    @discussion_space = nil
    @discussion = nil
  end
end