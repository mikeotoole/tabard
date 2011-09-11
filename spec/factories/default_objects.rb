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
  def self.clean
    @user = nil
    @user_profile = nil
    @wow = nil
    @swtor = nil
  end
end