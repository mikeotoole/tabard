# This class represents a cancan ability.
class Ability
  include CanCan::Ability

  ###
  # This method initalizes the abilites avalible to a user, using CanCan.
  ###
  def initialize(user)
    user ||= User.new

    ###
    # Baked in Rules
    ###
    can :manage, User do |some_user|
      user.id == some_user.id
    end
    can :read, UserProfile
    can :update, UserProfile do |user_profile|
      user.user_profile.id == user_profile.id
    end
    can [:read,:create], Community
    can :update, Community do |community|
      user.user_profile.id == community.admin_profile_id
    end
    can :manage, Role do |role|
      role.community_admin_profile_id == user.user_profile.id
    end
    cannot :destroy, Role do |role|
      role.system_generated
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
