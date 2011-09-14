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
    user ||= User.guest

  ###
  # Everyone, including guest, Rules
  ###
    # UserProfile Rules
    can :read, UserProfile
    # Community Rules
    can :read, Community
    # Character Rules
    can :read, BaseCharacter
    # Game Rules
    can :read, Game


    bakedInRules(user) if user.persisted? and user.user_profile and user.user_profile.persisted? # This ensures that only an actual user has these permissions.
    dynamicRules(user) unless user.community_profiles.blank?

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

    # Character Rules
    can :create, BaseCharacter
    can [:update, :destroy], BaseCharacter do |character|
      character.user_profile.id == user.user_profile.id
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

  ###
  # This method defines the dynamic rules for a user.
  # [Args]
  #   * +user+ -> A user to define permissions on. Ensures that they have at least one community_profile.
  ###
  def dynamicRules(user)
    return if user.community_profiles.empty?
    user.community_profiles.each do |community_profile|
      community_profile.roles.each do |role|
        role.permissions.each do |permission|
          if permission.action?
            case permission.permission_level
              when "Delete"
                decodePermission([:manage], permission.subject_class.constantize, permission.id_of_subject)
              when "Create"
                decodePermission([:read, :update, :create], permission.subject_class.constantize, permission.id_of_subject)
              when "Update"
                decodePermission([:read, :update], permission.subject_class.constantize, permission.id_of_subject)
              when "View"
                decodePermission([:read], permission.subject_class.constantize, permission.id_of_subject)
              else
                # TODO Joe/Bryan Should this be logged?
            end
          else
            decodePermission(permission.action.to_sym, permission.subject_class.constantize, permission.id_of_subject)
          end
        end
      end
    end
  end

  ###
  # This method decodes a permission to a cancan ability.
  # [Args]
  #   * +action+ -> This is a CanCan action to apply to the subject class.
  #   * +subject_class+ -> This is the class to apply the action to.
  #   * +subject_id+ -> This optional id specifies a specific instance of a subject class to apply the action to.
  ###
  def decodePermission(action, subject_class, subject_id = nil)
    if subject_id.blank?
      can action, subject_class
    else
      can action, subject_class do |subject_class_instance|
        subject_class_instance.id == subject_id
      end
    end
  end
end
