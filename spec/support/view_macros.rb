module ViewMacros
  def login_user(user=FactoryGirl.create(:user))
    controller.stub(:current_user) { user }
    
    # Setup for CanCan helpers (can? :action, object)
    controller.stub(:current_ability) { Ability.new(user) }
    controller.stub(:user_signed_in?) { not user.nil? }
  end
end