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
    can :reset_password, AdminUser do |admin_user|
      true
    end
    can [:reset_all_passwords], AdminUser do |admin_user|
      true
    end
    
    # Page Spaces Rules
    can [:create, :update], PageSpace do |page_space|
      true
    end
    
    # Discussion Spaces Rules
    can [:create, :update], DiscussionSpace do |discussion_space|
      true
    end
    
    # UserProfile Rules
    cannot :destroy, UserProfile do |profile|
      true
    end
    
    # User Rules
    can [:lock, :unlock, :reset_password], User do |user|
      true
    end
    can [:reset_all_passwords], User do |user|
      true
    end
  end
end