class DefaultObjects
  def self.user
    @user ||= FactoryGirl.create(:user)
  end
  def self.user_profile
    @user_profile ||= FactoryGirl.create(:user_profile, :user => DefaultObjects.user)
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

  def self.clean
    @user = nil
    @user_profile = nil
    @wow = nil
    @swtor = nil
    @wow_character_proxy = nil
    @swtor_character_proxy = nil
  end
end