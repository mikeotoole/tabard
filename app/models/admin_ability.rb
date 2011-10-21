class AdminAbility
  include CanCan::Ability

  ###
  # This method initalizes the abilites avalible to a user, using CanCan.
  # [Args]
  #   * +user+ -> This is the current_user, passed in from devise to CanCan.
  ###
  def initialize(user)
    user ||= AdminUser.new

    bakedInRules(user) if user.persisted?
  end
  
  ###
  # This method defines the baked in rules for a user.
  # [Args]
  #   * +user+ -> A user to define permissions on.
  ###
  def bakedInRules(user)
    can :manage, :all
    cannot :update, :all
  
    # AdminUser Rules
    can :update, AdminUser do |some_user|
      some_user.id == user.id
    end
    
    cannot :destroy, UserProfile do |profile|
      true
    end
  end
end