###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is the user class.
###
# This class is configured to work with devise to provide us authentication capabilities.
###
class User < ActiveRecord::Base
  validates_lengths_from_database
###
# Constants
###
  # This is the beta code
  BETA_CODE = "50DKPMINUS"
  # This determines if the beta code is required
  BETA_CODE_REQUIRED = true

###
# Devise configuration information
###
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :confirmable, :lockable

###
# Attribute accessors
###
  attr_accessor :birth_month, :birth_day, :birth_year, :is_partial_request, :remember_password, :beta_code

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_profile_attributes, :is_partial_request, :remember_password,
    :accepted_current_terms_of_service, :accepted_current_privacy_policy, :user_disabled_at, :date_of_birth, :birth_day, :birth_month, :birth_year,
    :time_zone, :beta_code, :is_email_on_message, :is_email_on_announcement

###
# Associations
###
  belongs_to :user_profile, inverse_of: :user, dependent: :destroy
  has_many :document_acceptances, dependent: :destroy
  has_many :accepted_documents, through: :document_acceptances, class_name: "Document", source: "document"
  accepts_nested_attributes_for :user_profile

###
# Callbacks
###
  after_save :update_document_acceptance
  before_validation :combine_birthday

###
# Delegates
###
  delegate :first_name, to: :user_profile, allow_nil: true
  delegate :last_name, to: :user_profile, allow_nil: true
  delegate :display_name, to: :user_profile, allow_nil: true
  delegate :description, to: :user_profile, allow_nil: true
  delegate :owned_communities, to: :user_profile, allow_nil: true
  delegate :community_profiles, to: :user_profile, allow_nil: true
  delegate :add_new_role, to: :user_profile, allow_nil: true
  delegate :roles, to: :user_profile, allow_nil: true
  delegate :character_proxies, to: :user_profile, allow_nil: true
  delegate :communities, to: :user_profile, allow_nil: true
  delegate :active_profile_helper_collection, to: :user_profile, allow_nil: true
  delegate :inbox, to: :user_profile, allow_nil: true
  delegate :trash, to: :user_profile, allow_nil: true
  delegate :address_book, to: :user_profile, allow_nil: true
  delegate :sent_messages, to: :user_profile, allow_nil: true
  delegate :unread_messages, to: :user_profile, allow_nil: true
  delegate :received_messages, to: :user_profile, allow_nil: true
  delegate :folders, to: :user_profile, allow_nil: true
  delegate :announcements, to: :user_profile, allow_nil: true
  delegate :acknowledgements, to: :user_profile, allow_nil: true
  delegate :read_announcements, to: :user_profile, allow_nil: true
  delegate :unread_announcements, to: :user_profile, allow_nil: true
  delegate :available_character_proxies, to: :user_profile, allow_nil: true
  delegate :has_seen?, to: :user_profile, allow_nil: true
  delegate :default_character_proxy_for_a_game, to: :user_profile, allow_nil: true
  delegate :is_member?, to: :user_profile, allow_nil: true
  delegate :application_pending?, to: :user_profile, allow_nil: true
  delegate :in_community, to: :user_profile, allow_nil: true
  delegate :remove_all_avatars, to: :user_profile, allow_nil: true
  delegate :avatar_url, to: :user_profile, allow_nil: true
  delegate :compatable_character_proxies, to: :user_profile, allow_nil: true
  delegate :invites, to: :user_profile, allow_nil: true
  delegate :events_invited_to, to: :user_profile, allow_nil: true
  delegate :invited?, to: :user_profile, allow_nil: true
  delegate :support_tickets, to: :user_profile, allow_nil: true
  delegate :pending_support_tickets, to: :user_profile, allow_nil: true
  delegate :in_progress_support_tickets, to: :user_profile, allow_nil: true
  delegate :closed_support_tickets, to: :user_profile, allow_nil: true

###
# Validators
###
  validates :user_profile, presence: true
  validates :email,
      uniqueness: true,
      length: { within: 5..128 },
      format: { with: %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i }

  validates :password,
      confirmation: true,
      length: { within: 8..30 },
      presence: true,
      format: {
        with: %r{^(.*)([a-z][A-Z]|[a-z][\d]|[a-z][\W]|[A-Z][a-z]|[A-Z][\d]|[A-Z][\W]|[\d][a-z]|[\d][A-Z]|[\d][\W]|[\W][a-z]|[\W][A-Z]|[\W][\d])(.*)$},
        message: "Must contain at least 2 of the following: lowercase letter, uppercase letter, number and punctuation symbols."
      },
      if: :password_required?

  validates :accepted_current_terms_of_service,
      acceptance: {accept: true},
      on: :create
  validates :accepted_current_privacy_policy,
      acceptance: {accept: true},
      on: :create
  validates :date_of_birth, presence: true
  validates :time_zone, presence: true, inclusion: { in: (-11..13).to_a, message: 'is not valid.' }
  validate :at_least_13_years_old
  with_options if: Proc.new{ BETA_CODE_REQUIRED and !Rails.env.test? } do |user|
    user.validates :beta_code, presence: {message: "is required for the closed beta"}, on: :create
    user.validate :valid_beta_key, on: :create
  end

###
# Public Methods
###

###
# Class Methods
###
  # This method returns a default guest user that is used to handle permissions.
  def self.guest
    user = User.new
    user.build_user_profile
    return user
  end

  # This will set force_logout to true on all users.
  def self.force_active_users_to_sign_out
    User.update_all(force_logout: true)
  end

  # This will reset all passwords for non disabled users.
  def self.reset_all_passwords
    User.where(admin_disabled_at: nil, user_disabled_at: nil).find_each do |user|
      User.delay.reset_user_password(user.id)
    end
  end

  # This is a class method to reset a users password.
  def self.reset_user_password(id)
    User.find(id).reset_password
  end

  # This is a class method to nuke a user.
  def self.nuke_user(id)
    User.find(id).nuke
  end

###
# Instance Methods
###

  # Returns the total cost for all users owned communities in cents.
  def total_price_per_month_in_cents
    cost = 0
    self.owned_communities.each do |community|
      cost = cost + community.total_price_per_month_in_cents
    end
    cost
  end

  # Returns the total cost for all users owned communities in dollars.
  def total_price_per_month_in_dollars
    self.total_price_per_month_in_cents/100.0
  end

  def new_total_price_per_month_in_cents(community)
    cost = community.total_price_per_month_in_cents
    self.owned_communities.all(:conditions => ["id != ?", community.id]).each do |community|
      cost = cost + community.total_price_per_month_in_cents
    end
    cost
  end

  def update_stripe(stripe_card_token, new_total_cost)
    if new_total_cost == 0
      # Need to cancel subscription
      if self.stripe_customer_token.present?
        c = Stripe::Customer.retrieve(self.stripe_customer_token)
        s = c.cancel_subscription if c.subscription.present?
      end
      return true
    else
      # Find plan with this total cost.
      plan = StripePlan.find_or_create_by_amount(new_total_cost) #TODO Handle any errors in creation.
      if self.stripe_customer_token.present?
        c = Stripe::Customer.retrieve(self.stripe_customer_token)
        if stripe_card_token.present?
          # Update credit card info and subscription
          c.update_subscription(plan: plan.strip_id, prorate: true, card: stripe_card_token)
        else
          # Update subscription
          c.update_subscription(plan: plan.strip_id, prorate: true)
        end
      else
        # Create new Stripe customer for community admin and subscribe to Stripe plan.
        customer = Stripe::Customer.create(description: "User ID: #{self.id}",
                                                 email: self.email,
                                                 plan: plan.strip_id,
                                                 card: stripe_card_token)
        self.stripe_customer_token = customer.id
        self.save!
      end
      return true
    end
  end

###
# Doc Acceptance
###
  #This method checks to see if the user has accepted the most recent version of the Terms of Service.
  def has_accepted_current_terms_of_service?
    accepted_documents.include?(TermsOfService.current)
  end

  #This method checks to see if the user has accepted the most recent version of the Privacy Policy.
  def has_accepted_current_privacy_policy?
    accepted_documents.include?(PrivacyPolicy.current)
  end

  #This method checks to see if the user has accepted the most recent version of all legal documents.
  def has_accepted_all_documents?
    has_accepted_current_terms_of_service? and has_accepted_current_privacy_policy?
  end
  #Updates documment acceptance cache.
  def update_acceptance_of_documents(document)
    self.update_attributes(accepted_current_terms_of_service: true) if document == TermsOfService.current
    self.update_attributes(accepted_current_privacy_policy: true) if document == PrivacyPolicy.current
    doc_acceptance = self.document_acceptances.find_by_document_id(document.id)
    doc_acceptance.update_column(:is_current, true) unless doc_acceptance == nil
  end

###
# Authentication
###
  ###
  # This method determines if the user is active. It is adding to the existing Devise method.
  # [Returns] True if this is an active user, otherwise false.
  ###
  def active_for_authentication?
    super and not self.is_disabled?
  end

  ###
  # This method overrides the existing Devise method to check it account is disabled.
  # [Returns] :suspended if account is suspended otherwise it returns super's response.
  ###
  def inactive_message
    if self.admin_disabled_at
      :admin_disabled
    elsif self.user_disabled_at
      :user_disabled
    else
      super
    end
  end

  # This method overrides devise to add a password changed hook.
  def update_with_password(params, *options)
    if valid_password?(params[:current_password])
      unless params[:password].blank? or params[:password_confirmation].blank?
        #send out some emails, user is changing password
        UserMailer.delay.password_changed(self.id)
      end
    end
    super
  end

  ###
  # This method determines if the password is required. It is used to determine if password needs to be validated.
  # [Returns] True if this is a new record or if password is present, otherwise false.
  ###
  def password_required?
    self.new_record? || self.password.present?
  end

  # Will reset the users password.
  def reset_password
    random_password = User.send(:generate_token, 'encrypted_password').slice(0, 8)
    self.password = random_password if random_password
    self.password_confirmation = random_password if random_password
    self.reset_password_token = User.reset_password_token
    self.reset_password_sent_at = Time.now
    self.save(validate: false)
    UserMailer.password_reset(self, random_password).deliver
  end

  # Checks if this user is disabled.
  def is_disabled?
    self.admin_disabled_at or self.user_disabled_at
  end

  ###
  # Used to disable a user.
  # [Args]
  #   * +params+ -> a hash that should contain a user with current password.
  ###
  def disable_by_user(params)
    if(params[:user])
      params[:user][:user_disabled_at] = Time.now
      success = self.update_with_password(params[:user])
      if success
        disable_user
      end
      return success
    else
      return false
    end
  end

  # Used by the admin panel to disable a user.
  def disable_by_admin
    if self.update_column(:admin_disabled_at, Time.now)
      disable_user
    end
  end

  # Disables the user
  def disable_user
    self.remove_from_all_communities
    self.remove_all_avatars
    self.update_column(:accepted_current_terms_of_service, false)
    self.update_column(:accepted_current_privacy_policy, false)
    tos = self.document_acceptances.find_by_document_id(TermsOfService.current.id)
    pp = self.document_acceptances.find_by_document_id(PrivacyPolicy.current.id)
    tos.update_column(:is_current, false) unless tos == nil
    pp.update_column(:is_current, false) unless pp == nil
  end

  # Removes user from all communities.
  def remove_from_all_communities
    self.owned_communities.clear if self.owned_communities
    self.community_profiles.clear if self.community_profiles
  end

  # User by the admin panel to reactivate a user. This will set both is_admin_disabled and is_user_disabled to false.
  def reinstate_by_admin
    self.update_column(:admin_disabled_at, nil)
    self.update_column(:user_disabled_at, nil)
  end

  # This will send an email for a user to reactivate their account.
  def reinstate_by_user
    if self.user_disabled_at
      self.reset_password_token = User.reset_password_token
      self.reset_password_sent_at = Time.now
      self.save(validate: false)
      UserMailer.reinstate_account(self).deliver
    else
      false
    end
  end

  # This will destroy forever this user and all its associated resources.
  def nuke
    self.disable_by_admin
    self.user_profile.nuke if self.user_profile
    User.find(self).destroy
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  # This method combines the individual birthday fields into one date
  def combine_birthday
    if self.date_of_birth.blank? and !self.birth_year.blank? and !self.birth_month.blank? and !self.birth_day.blank?
      begin
        self.date_of_birth = Date.new(self.birth_year.to_i,self.birth_month.to_i,self.birth_day.to_i).to_time_in_current_zone.to_date
      rescue
        self.errors.add(:date_of_birth, "invalid")
      end
    else
      true
    end
  end

  #This method updates the acceptance of documents
  def update_document_acceptance
    self.accepted_documents << TermsOfService.current if self.accepted_current_terms_of_service and not has_accepted_current_terms_of_service?
    self.accepted_documents << PrivacyPolicy.current if self.accepted_current_privacy_policy and not has_accepted_current_privacy_policy?
  end

###
# Validator Mathods
###
  # This validation method ensures that the user is 13 years of age according to the date_of_birth.
  def at_least_13_years_old
    errors.add(:date_of_birth, "you must be 13 years of age to use this service") if !self.date_of_birth? or (Time.zone.now - 13.years).to_date < self.date_of_birth
  end
  # This validates the beta code
  def valid_beta_key
    errors.add(:beta_code, "is invalid") if self.beta_code and self.beta_code.gsub(/\s+/,"").upcase != BETA_CODE
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                :integer          not null, primary key
#  email                             :string(255)      default(""), not null
#  encrypted_password                :string(255)      default(""), not null
#  reset_password_token              :string(255)
#  reset_password_sent_at            :datetime
#  remember_created_at               :datetime
#  confirmation_token                :string(255)
#  confirmed_at                      :datetime
#  confirmation_sent_at              :datetime
#  unconfirmed_email                 :string(255)
#  failed_attempts                   :integer          default(0)
#  unlock_token                      :string(255)
#  locked_at                         :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  accepted_current_terms_of_service :boolean          default(FALSE)
#  accepted_current_privacy_policy   :boolean          default(FALSE)
#  force_logout                      :boolean          default(FALSE)
#  date_of_birth                     :date
#  user_disabled_at                  :datetime
#  admin_disabled_at                 :datetime
#  user_profile_id                   :integer
#  time_zone                         :integer          default(-8)
#  is_email_on_message               :boolean          default(TRUE)
#  is_email_on_announcement          :boolean          default(TRUE)
#  stripe_customer_token             :string(255)
#

