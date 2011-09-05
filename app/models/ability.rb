###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a cancan ability.
###
class Ability
  include CanCan::Ability

  ###
  # This method initalizes the abilites avalible to a user, using CanCan.
  # [Args]
  #   * +user+ -> This is the current_user, passed in from devise to CanCan.
  ###
  def initialize(user)
    user ||= User.new

  ###
  # Everyone, including guest, Rules
  ###
    # UserProfile Rules
    can :read, UserProfile
    # Community Rules
    can :read, Community

    bakedInRules(user) if user.persisted? # This ensures that only an actual user has these permissions.
    # TODO Add dynamic rules

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

  ###
  # This method defines the baked in rules for a user.
  # [Args]
  #   * +user+ -> A user to define permissions on.
  ###
  def bakedInRules(user)
    # User Rules
    can :manage, User do |some_user|
      some_user.id == user.id
    end

    can :update, UserProfile do |user_profile|
      user_profile.id == user.user_profile.id
    end

    # Community Rules
    can :create, Community
    can :update, Community do |community|
      community.admin_profile_id == user.user_profile.id
    end

    # Role Rules
    can :manage, Role do |role|
      role.community_admin_profile_id == user.user_profile.id
    end
    cannot :destroy, Role do |role|
      role.system_generated
    end

    # Permission Rules
    can :manage, Permission do |permission|
      permission.community_admin_profile_id == user.user_profile.id
    end
  end
end
