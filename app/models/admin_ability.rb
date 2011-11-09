class AdminAbility
  include CanCan::Ability

  ###
  # This method initalizes the abilites avalible to a user, using CanCan.
  # [Args]
  #   * +user+ -> This is the current_user, passed in from devise to CanCan.
  ###
  def initialize(user)
    user ||= AdminUser.new

    bakedInRules(user) if user.persisted? and user.is_a?(AdminUser)
  end
  
  ###
  # This method defines the baked in rules for a user.
  # [Args]
  #   * +user+ -> A user to define permissions on.
  ###
  def bakedInRules(user)  
    # Rules for moderator user.
    if user.role? :moderator # TODO Bryan, Review all these rules -MO
      can [:read], ActiveAdmin::Dashboards::DashboardController
      can [:read, :lock, :unlock, :reset_password], User
      can [:read], UserProfile
      can [:read, :destroy], Community
      can [:read, :destroy, :delete_question], CustomForm
      can [:read, :destroy, :delete_predefined_answer], Question
      can [:read, :destroy, :update], PageSpace
      can [:read, :destroy], Page
      can [:read, :destroy, :update], DiscussionSpace
      can [:read, :destroy, :remove_comment], Discussion
      can [:read, :destroy], SwtorCharacter
      can [:read, :destroy], WowCharacter
    end
    
    # Rules for admin user. (Inherits rules for moderator).
    if user.role? :admin # TODO Bryan, Review all these rules -MO
      can [:destroy, :reset_all_passwords, :sign_out_all_users], User
      can [:toggle_maintenance_mode], SiteActionController
    end
    
    # Rules for superadmin user. (Inherits rules for admin).
    if user.role? :superadmin # TODO Bryan, Review all these rules -MO
      can :create, [AdminUser, 'Admin User'] # Quoted needed for displaying button in panel.
      can :manage, [AdminUser]
    end
  end
end