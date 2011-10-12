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
    can :read, UserProfile do |user_profile|
      user_profile.publicly_viewable
    end
    # Community Rules
    can :read, Community
    # Character Rules
    can :read, BaseCharacter
    # Game Rules
    can :read, Game


    bakedInRules(user) if user.persisted? and user.user_profile and user.user_profile.persisted? # This ensures that only an actual user has these permissions.
    #dynamicRules(user, current_community) unless user.community_profiles.blank?

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

    # UserProfile Rules
    can :read, UserProfile
    can :update, UserProfile do |user_profile|
      user_profile.id == user.user_profile.id
    end

    # Community Rules
    can :create, Community
    can :update, Community do |community|
      community.admin_profile_id == user.user_profile.id
    end

    # RosterAssignments
    can [:read, :create, :update, :destroy], RosterAssignment do |roster_assignment|
      roster_assignment.community_profile_user_profile.id == user.user_profile.id if roster_assignment.community_profile_user_profile
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

    # Character Rules
    can :create, BaseCharacter
    can [:update, :destroy], BaseCharacter do |character|
      character.user_profile.id == user.user_profile.id
    end

    # Custom Form Rules
    can :read, CustomForm
    can :manage, CustomForm do |form|
      form.community.admin_profile_id == user.user_profile.id
    end

    # Question Form Rules
    can :read, Question
    can :manage, Question do |question|
      question.custom_form.admin_profile_id == user.user_profile.id
    end

    # Submission Rules
    can :create, Submission
    can [:read, :destroy], Submission do |submission|
      submission.admin_profile_id == user.user_profile.id or
      submission.user_profile_id == user.user_profile.id
    end
    can [:update], Submission do |answer|
      submission.user_profile_id == user.user_profile.id
    end

    # Answer Rules
    can :create, Answer
    can [:read, :destroy], Answer do |answer|
      answer.submission.admin_profile_id == user.user_profile.id or
      answer.user_profile_id == user.user_profile.id
    end
    can [:update], Answer do |answer|
      answer.user_profile_id == user.user_profile.id
    end

    # Discussion Rules
    can [:read, :create], Discussion do |discussion|
      user.user_profile.is_member?(discussion.community)
    end
    can [:update], Discussion do |discussion|
      (discussion.user_profile_id == user.user_profile.id) and not discussion.has_been_locked
    end
    can [:destroy], Discussion do |discussion|
      (discussion.community.admin_profile_id == user.user_profile.id and not discussion.has_been_locked) or
      ((discussion.user_profile_id == user.user_profile.id) and not discussion.has_been_locked)
    end
    can [:unlock, :lock], Discussion do |discussion|
      discussion.community.admin_profile_id == user.user_profile.id
    end
    cannot :create, Discussion do |discussion|
      if discussion.is_announcement
        discussion.community.admin_profile_id != user.user_profile.id
      else
        false
      end
    end

    # Comment Rules
    can [:read, :create], Comment do |comment|
      user.user_profile.is_member?(comment.community)
    end
    can [:update], Comment do |comment|
      (comment.user_profile_id == user.user_profile.id) and not comment.has_been_locked and not comment.has_been_deleted
    end
    can [:destroy], Comment do |comment|
      ((comment.community_admin_profile_id == user.user_profile.id and not comment.has_been_locked) or
      ((comment.user_profile_id == user.user_profile.id) and not comment.has_been_locked)) and not comment.has_been_deleted
    end
    can [:unlock, :lock], Comment do |comment|
      (comment.community_admin_profile_id == user.user_profile.id) and not comment.has_been_deleted
    end

    # Discussion Space Rules
    can [:read], DiscussionSpace do |space|
      user.user_profile.is_member?(space.community)
    end
    can [:update, :destroy, :create], DiscussionSpace do |space|
      space.community.admin_profile_id == user.user_profile.id
    end
    cannot [:update, :destroy, :create], DiscussionSpace do |space|
      space.is_announcement == true
    end

    # Pages Rules
    can [:read, :create], Page do |page|
      user.user_profile.is_member?(page.community)
    end
    can [:update], Page do |page|
      page.user_profile_id == user.user_profile.id
    end
    can [:destroy], Page do |page|
      page.community.admin_profile_id == user.user_profile.id or
      page.user_profile_id == user.user_profile.id
    end

    # Page Space Rules
    can [:read], PageSpace do |space|
      user.user_profile.is_member?(space.community)
    end
    can [:update, :destroy, :create], PageSpace do |space|
      space.community.admin_profile_id == user.user_profile.id
    end

    # Community Applications
    can [:read, :create, :update, :destroy], CommunityApplication do |community_application|
      community_application.user_profile.id == user.user_profile.id if community_application.user_profile
    end
    can [:read, :accept, :reject], CommunityApplication do |community_application|
      community_application.community_admin_profile_id == user.user_profile.id
    end

    # Messaging Rules
    can :manage, Folder do |folder|
      folder.user_profile_id == user.user_profile.id
    end
    cannot :destroy, Folder do |folder|
      true
    end
    can :manage, Message do |message|
      message.author_id == user.user_profile.id
    end
    cannot [:update, :destroy], Message do |message|
      true
    end
    can :manage, MessageAssociation do |message|
      message.recipient_id == user.user_profile.id
    end
  end

  ###
  # This method defines the dynamic rules for a user.
  # [Args]
  #   * +user+ -> A user to define permissions on. Ensures that they have at least one community_profile.
  ###
  def dynamicContextRules(user, current_community)
    # Special admin rules for community owner
    can :manage, RosterAssignment if current_community and current_community.admin_profile_id == user.user_profile_id

    # Check for rules granted by roles
    return if user.community_profiles.empty? or not user.community_profiles.find_by_community_id(current_community.id)
    community_profile = user.community_profiles.find_by_community_id(current_community.id)
    community_profile.roles.each do |role|
      role.permissions.each do |permission|
        action = Array.new
        case permission.permission_level
          when "Delete"
            action.concat([:read, :update, :create, :destroy])
          when "Create"
            action.concat([:read, :update, :create])
          when "Update"
            action.concat([:read, :update])
          when "View"
            action.concat([:read])
          else
            # TODO Joe/Bryan Should this be logged?
        end
        action.concat([:lock]) if permission.can_lock
        action.concat([:accept]) if permission.can_accept
        if permission.parent_association_for_subject.blank?
          decodePermission(action, permission.subject_class.constantize, permission.id_of_subject)
        else
          decodeNestedPermission(action, permission.subject_class.constantize, permission.parent_association_for_subject, permission.id_of_parent)
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

  ###
  # This method decodes a permission to a cancan ability.
  # [Args]
  #   * +action+ -> This is a CanCan action to apply to the subject class.
  #   * +subject_class+ -> This is the class to apply the action to.
  #   * +parent_relation+ -> This is the method to use to find the parent so that the id can be verified.
  #   * +parent_id+ -> This is the id of the parent.
  ###
  def decodeNestedPermission(action, subject_class, parent_relation, parent_id)
    can action, subject_class do |subject_class_instance|
      subject_class_instance.send(parent_relation).id == subject_id
    end
  end
end
