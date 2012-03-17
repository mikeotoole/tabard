###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a cancan ability used for Users.
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
    anonymous_user_rules(user)
    site_member_rules(user) if user.persisted? and user.user_profile and user.user_profile.persisted? # This ensures that only an actual user has these permissions.

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
  # This method defines the rules for an anonymous user.
  # [Args]
  #   * +user+ -> A user to define permissions on.
  ###
  def anonymous_user_rules(user)
    # Community Rules
    can :read, Community
    # Game Rules
    can :read, Game
    # UserProfile Rules
    can :read, UserProfile
    # User Rules
    can :create, User
    # ArtworkUpload Rules
    can :create, ArtworkUpload
  end
=begin
  can :manage, Answer
  can :manage, BaseCharacter
  can :manage, CharacterProxy
  can :manage, Comment
  can :manage, Community
  can :manage, CommunityApplication
  can :manage, CommunityProfile
  can :manage, CustomForm
  can :manage, Discussion
  can :manage, DiscussionSpace
  can :manage, Folder
  can :manage, Game
  can :manage, Message
  can :manage, MessageAssociation
  can :manage, MultiSelectQuestion
  can :manage, Page
  can :manage, PageSpace
  can :manage, Permission
  can :manage, PredefinedAnswer
  can :manage, Question
  can :manage, Role
  can :manage, RosterAssignment
  can :manage, SelectQuestion
  can :manage, SingleSelectQuestion
  can :manage, Submission
  can :manage, SupportedGame
  can :manage, Swtor
  can :manage, SwtorCharacter
  can :manage, TextQuestion
  can :manage, User
  can :manage, UserProfile
  can :manage, ViewLog
  can :manage, Wow
  can :manage, WowCharacter
=end

  ###
  # This method defines the rules for a member.
  # [Args]
  #   * +user+ -> A user to define permissions on.
  ###
  def site_member_rules(user)
    can :dashboard, UserProfile do |user_profile|
      user_profile == user.user_profile
    end
    # Character Rules
    can :create, BaseCharacter
    can [:update, :destroy], BaseCharacter do |character|
      character.user_profile.id == user.user_profile_id
    end

    #Discussion Rules
    can [:update, :destroy], Discussion do |discussion|
      (discussion.user_profile_id == user.user_profile_id) and not discussion.is_locked
    end

    # Comment Rules
    can [:update,:destroy], Comment do |comment|
      ((comment.user_profile_id == user.user_profile_id) and not comment.is_locked and not comment.is_removed)
    end

    # Community Rules
    can :create, Community
    can :destroy, Community do |community|
      community.admin_profile_id == user.user_profile_id
    end

    # Community Applications
    can [:create, :update, :destroy], CommunityApplication do |community_application|
      community_application.user_profile_id == user.user_profile_id if community_application.user_profile_id
    end
    can [:comment], CommunityApplication do |community_application|
      can? :create, Comment.new({ :commentable => community_application, :community => community_application.community }, :without_protection => true)
    end

    # Discussion Rules
    can [:comment], Discussion do |discussion|
      can? :read, discussion and not discussion.is_locked
    end
    can [:update, :destroy], Discussion do |discussion|
      (discussion.user_profile_id == user.user_profile_id) and not discussion.is_locked
    end

    #Event Rules
    can :read, Event do |event|
      user.events_invited_to.include?(event)
    end

    #Invite Rules
    can [:read, :update], Invite do |invite|
      invite.user_profile_id == user.user_profile_id
    end

    # Messaging Rules
    can :manage, Folder do |folder|
      folder.user_profile_id == user.user_profile_id
    end
    cannot :destroy, Folder
    can :manage, Message do |message|
      message.author_id == user.user_profile_id
    end
    cannot [:update, :destroy], Message do |message|
      true
    end
    can :manage, MessageAssociation do |message_association|
      message_association.recipient_id == user.user_profile_id
    end

    # Question Form Rules
    can :read, Question

    # Submission Rules
    can :create, Submission
    can [:read, :destroy], Submission do |submission|
      submission.user_profile_id == user.user_profile_id
    end

    # User Rules
    can :manage, User do |some_user|
      some_user.id == user.id
    end

    # UserProfile Rules
    can :read, UserProfile do |user_profile|
      user_profile.id == user.user_profile_id
    end
    can :update, UserProfile do |user_profile|
      user_profile.id == user.user_profile_id
    end

    # Supported Game Rules
    can [:read], SupportedGame do |supported_game|
      user.user_profile.is_member?(supported_game.community)
    end
    can [:update, :destroy, :create], SupportedGame do |supported_game|
      supported_game.community_admin_profile_id == user.user_profile_id
    end
  end

  ###
  # This method defines the rules for a user who is a community member.
  # [Args]
  #   * +user+ -> A user to define permissions on.
  ###
  def community_member_rules(user, current_community)
    apply_rules_from_roles(user, current_community)

    can :read, Announcement

    can :index, PageSpace

    can [:read], Comment do |comment|
      user.user_profile.is_member?(current_community)
    end

    can [:comment], Announcement do |announcement|
      not announcement.is_locked and can? :create, Comment.new({ :commentable => announcement, :community => announcement.community }, :without_protection => true)
    end

    can :mine, RosterAssignment
    can [:read, :create, :destroy], RosterAssignment do |roster_assignment|
      roster_assignment.community_profile_user_profile_id == user.user_profile_id if roster_assignment.community_profile_user_profile
    end

    can [:destroy], CommunityProfile do |community_profile|
      community_profile.user_profile_id == user.user_profile_id
    end
    
    can [:read], Event do |event|
      event.is_public # TODO Joe/Mike, Need to check if user has invite. -MO
    end
  end

  ###
  # This method defines the rules for a user who is a community admin.
  # [Args]
  #   * +user+ -> A user to define permissions on.
  ###
  def community_admin_rules(user)
    can [:read], Answer
    can :destroy, CommunityProfile do |community_profile|
      community_profile.user_profile != community_profile.community.admin_profile
    end
    can :manage, RosterAssignment
    can [:read, :accept, :reject], CommunityApplication
    can [:manage], Page
    can [:manage], PageSpace
    can [:unlock, :lock, :destroy], Comment do |comment|
      not comment.is_removed
    end

    can :manage, Announcement do |announcement|
      announcement.community_admin_profile_id == user.user_profile_id
    end

    can :manage, DiscussionSpace
    can :manage, Discussion do |discussion|
      not discussion.is_locked
    end
    can :unlock, Discussion
    can :manage, CustomForm
    cannot :delete, CustomForm do |form|
      form.application_form?
    end
    can :manage, Role
    cannot :destroy, Role do |role|
      role.is_system_generated
    end
    can :manage, Permission
    can [:read, :destroy], Submission
    can :manage, Question
    can [:update, :remove_confirmation, :clear_action_items], Community
    
    can :manage, Event
  end

  ###
  # This method defines the dynamic rules for a user.
  # [Args]
  #   * +user+ -> A user to define permissions on. Ensures that they have at least one community_profile.
  #   * +current_community+ -> The current community context.
  ###
  def dynamicContextRules(user, current_community)
    if user
      community_member_rules(user, current_community) if user.is_member?(current_community)
      community_admin_rules(user) if current_community.admin_profile_id == user.user_profile_id
    end

    # Special context rules
    can [:create], Submission do |submission|
      submission.custom_form_is_published and can? :read, submission.custom_form
    end

    # Cannot Overrides
    cannot [:show], CommunityApplication do |community_application|
      community_application.user_profile_id == user.user_profile_id
    end

    cannot [:create], Comment do |comment|
      comment.commentable_has_comments_disabled?
    end
    cannot [:update, :destroy], Comment do |comment|
      comment.replies_locked?
    end
    cannot :update, Comment do |comment|
      (comment.user_profile_id != user.user_profile_id)
    end
    cannot :update, Discussion do |discussion|
      (discussion.user_profile_id != user.user_profile_id)
    end
  end

  ###
  # This method adds permissions from the roles.
  # [Args]
  #   * +user+ -> A user to define permissions on. Ensures that they have at least one community_profile.
  #   * +current_community+ -> The current community context.
  ###
  def apply_rules_from_roles(user, current_community)
    return if user == nil
    return if user.community_profiles.empty? or not user.community_profiles.find_by_community_id(current_community.id)
    community_profile = user.community_profiles.find_by_community_id(current_community.id)
    community_profile.roles.each do |role|
      role.permissions.each do |permission|
        action = Array.new
        if not permission.permission_level?
          action.concat([:read]) if permission.can_read
          action.concat([:update]) if permission.can_update
          action.concat([:create]) if permission.can_create
          action.concat([:destroy]) if permission.can_destroy
        else
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
              logger.error "Invalid permission attempting to be decoded."
              logger.error permisson.to_yaml
          end
        end
        if permission.can_lock
          action.concat([:lock])
          action.concat([:unlock])
        end
        if permission.can_accept
          action.concat([:accept])
          action.concat([:reject])
        end
        if !permission.parent_association_for_subject?
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
      case subject_class.to_s
      when "DiscussionSpace"
        if action.include?(:read) and subject_class != nil
          can :read, Discussion do |discussion|
            discussion.discussion_space_id == subject_id
          end
        end
      when "PageSpace"
        if action.include?(:read) and subject_class != nil
          can :read, Page do |page|
            page.page_space_id == subject_id
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
  #   * +parent_relation+ -> This is the method to use to find the parent so that the id can be verified.
  #   * +parent_id+ -> This is the id of the parent.
  ###
  def decodeNestedPermission(action, subject_class, parent_relation, parent_id)
    can action, subject_class do |subject_class_instance|
      subject_class_instance.send(parent_relation).id == parent_id
    end
  end
end
