class DefaultObjects
  def self.user
    @user ||= DefaultObjects.user_profile.user
  end
  
  def self.user_profile
    @user_profile ||= FactoryGirl.create(:user_profile, :user => FactoryGirl.create(:user))
    if not @user_profile.is_member?(DefaultObjects.community)
      app = FactoryGirl.create(:community_application,
        :community => DefaultObjects.community,
        :user_profile => @user_profile,
        :submission => FactoryGirl.create(:submission, :custom_form => DefaultObjects.community.community_application_form, :user_profile => @user_profile),
        :character_proxies => []
      )
      app.accept_application
    end
    @user_profile
  end

  def self.additional_community_user_profile
    @additional_community_user_profile ||= FactoryGirl.create(:user_profile_with_characters, :user => FactoryGirl.create(:user))
    if not @additional_community_user_profile.is_member?(DefaultObjects.community)
      app = FactoryGirl.create(:community_application,
          :community => DefaultObjects.community,
          :user_profile => @additional_community_user_profile,
          :submission => FactoryGirl.create(:submission, :custom_form => DefaultObjects.community.community_application_form, :user_profile => @additional_community_user_profile),
          :character_proxies => @additional_community_user_profile.character_proxies
        )
      app.accept_application
    end
    @additional_community_user_profile
  end

  def self.fresh_user_profile
    @fresh_user_profile ||= FactoryGirl.create(:user_profile_with_characters, :user => FactoryGirl.create(:user))
  end
  
  def self.wow
    @wow ||= FactoryGirl.create(:wow)
  end
  
  def self.swtor
    @swtor ||= FactoryGirl.create(:swtor)
  end

  def self.wow_character_proxy
    @wow_character_proxy ||= FactoryGirl.create(:character_proxy_with_wow_character)
  end

  def self.swtor_character_proxy
    @swtor_character_proxy ||= FactoryGirl.create(:character_proxy_with_swtor_character)
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
    @discussion ||= FactoryGirl.create(:discussion)
  end
  
  def self.clean
    @user = nil
    @user_profile = nil
    @additional_community_user_profile = nil
    @fresh_user_profile = nil
    @wow = nil
    @swtor = nil
    @community = nil
    @custom_form = nil
    @community_admin = nil
    @wow_character_proxy = nil
    @swtor_character_proxy = nil
    @discussion_space = nil
    @discussion = nil
  end
end