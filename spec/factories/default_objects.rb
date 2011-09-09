class DefaultObjects
  def self.user_profile
    @default_user_profile ||= FactoryGirl.create(:user_profile)
  end
end