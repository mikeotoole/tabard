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
    if user.role? :moderator
      can [:read], ActiveAdmin::Dashboards::DashboardController
      can [:read, :disable, :reinstate, :reset_password], User
      can [:read], UserProfile
      can [:read], Community
      can [:read, :destroy, :delete_question], CustomForm
      cannot [:destroy], CustomForm do |custom_form|
        custom_form.application_form?
      end
      can [:read, :delete_predefined_answer, :destroy], Question
      can [:read, :destroy, :update], PageSpace
      can [:read, :destroy], Page
      can [:read], DiscussionSpace
      can [:update, :destroy], DiscussionSpace
      can [:read, :destroy, :remove_comment], Discussion
      can [:read, :update], CommunityGame
      can [:read], CommunityApplication
      can [:read], Character
      can [:read], Game
      can [:update_account, :edit_account], AdminUser do |admin_user|
        admin_user == user
      end
    end

    # Rules for admin user. (Inherits rules from moderator).
    if user.role? :admin
      can [:nuke, :reset_all_passwords, :sign_out_all_users], User
      can [:destroy], Community
      can [:destroy], CommunityGame
      can [:destroy], Character
      can [:read, :create, :update], [Game, 'Game']
      can [:toggle_maintenance_mode], SiteConfigurationController
      can :manage, ArtworkUpload
      can [:read, :update], SupportTicket
      can [:read, :create], SupportComment
      can [:read], Invoice
      can [:read], InvoiceItem
    end

    # Rules for superadmin user. (Inherits rules from admin).
    if user.role? :superadmin
      can [:charge_exempt, :charge_exempt_edit], Community
      can [:read, :create, :view_document], [Document, 'Document']
      can [:update], Document do |document|
        not document.is_published
      end
      can :create, [AdminUser, 'AdminUser'] # Quoted needed for displaying button in panel.
      can :manage, AdminUser
      cannot [:update_account, :edit_account], AdminUser do |admin_user|
        admin_user != user
      end
    end
  end
end
