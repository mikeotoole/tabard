###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a cancan ability used for AdminUsers.
###
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
      can [:read, :disable, :reinstate, :reset_password], User
      can [:read], UserProfile
      can [:read], Community
      can [:read, :destroy, :delete_question], CustomForm
      cannot [:destroy], CustomForm do |custom_form|
        false # custom_form.application_form? # TODO Mike, Fix me.
      end
      can [:read, :delete_predefined_answer, :destroy], Question
      can [:read, :destroy, :update], PageSpace
      can [:read, :destroy], Page
      can [:read], DiscussionSpace
      can [:update, :destroy], DiscussionSpace do |space|
        space.is_announcement != true
      end
      can [:read, :destroy, :remove_comment], Discussion
      can [:read, :update], SupportedGame
      can [:read], SwtorCharacter
      can [:read], WowCharacter
      can [:update_account, :edit_account], AdminUser do |admin_user|
        admin_user == user
      end
    end

    # Rules for admin user. (Inherits rules from moderator).
    if user.role? :admin # TODO Bryan, Review all these rules -MO
      can [:nuke, :reset_all_passwords, :sign_out_all_users], User
      can [:destroy], SwtorCharacter
      can [:destroy], WowCharacter
      can [:destroy], Community
      can [:destroy], SupportedGame
      can [:read, :create, :update], [Wow, 'Wow']
      can [:read, :create, :update], [Swtor, 'Swtor']
      can [:toggle_maintenance_mode], SiteActionController
    end

    # Rules for superadmin user. (Inherits rules from admin).
    if user.role? :superadmin # TODO Bryan, Review all these rules -MO
      can [:read, :create, :view_document], [Document, 'Document']
      can [:update], Document do |document|
        not Document.find(document).published
      end
      can :create, [AdminUser, 'Admin User'] # Quoted needed for displaying button in panel.
      can :manage, AdminUser
      cannot [:update_account, :edit_account], AdminUser do |admin_user|
        admin_user != user
      end
    end
  end
end
