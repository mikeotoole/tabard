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
    can [:read, :destroy], :all
    cannot [:update, :create], :all
  
    # AdminUser Rules
    can :update, AdminUser do |admin_user|
      admin_user.id == user.id
    end
    can :create, AdminUser do |admin_user|
      true
    end
    
    # Page Spaces Rules
    can [:create, :update], PageSpace do |space|
      true
    end
    
    # Discussion Spaces Rules
    can [:create, :update], DiscussionSpace do |space|
      true
    end
    
    # UserProfile Rules
    cannot :destroy, UserProfile do |profile|
      true
    end
  end
end