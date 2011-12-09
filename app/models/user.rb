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
###
# Devise configuration information
###
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :lockable

###
# Attribute accessors
###
  attr_accessor :birth_month, :birth_day, :birth_year

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_profile_attributes, :user_profile,
    :accepted_current_terms_of_service, :accepted_current_privacy_policy, :user_disabled_at, :date_of_birth, :birth_day, :birth_month, :birth_year

###
# Associations
###
  has_one :user_profile, :inverse_of => :user, :dependent => :destroy
  has_many :document_acceptances, :dependent => :destroy
  has_many :accepted_documents, :through => :document_acceptances, :class_name => "Document", :source => "document"
  accepts_nested_attributes_for :user_profile

###
# Callbacks
###
  after_save :update_document_acceptance
  before_validation :combine_birthday

###
# Delegates
###
  delegate :id, :to => :user_profile, :prefix => true, :allow_nil => true
  delegate :first_name, :to => :user_profile, :allow_nil => true
  delegate :last_name, :to => :user_profile, :allow_nil => true
  delegate :display_name, :to => :user_profile, :allow_nil => true
  delegate :description, :to => :user_profile, :allow_nil => true
  delegate :owned_communities, :to => :user_profile, :allow_nil => true
  delegate :community_profiles, :to => :user_profile, :allow_nil => true
  delegate :add_new_role, :to => :user_profile, :allow_nil => true
  delegate :roles, :to => :user_profile, :allow_nil => true
  delegate :character_proxies, :to => :user_profile, :allow_nil => true
  delegate :communities, :to => :user_profile, :allow_nil => true
  delegate :active_profile_helper_collection, :to => :user_profile, :allow_nil => true
  delegate :inbox, :to => :user_profile, :allow_nil => true
  delegate :trash, :to => :user_profile, :allow_nil => true
  delegate :address_book, :to => :user_profile, :allow_nil => true
  delegate :sent_messages, :to => :user_profile, :allow_nil => true
  delegate :unread_messages, :to => :user_profile, :allow_nil => true
  delegate :received_messages, :to => :user_profile, :allow_nil => true
  delegate :folders, :to => :user_profile, :allow_nil => true
  delegate :announcements, :to => :user_profile, :allow_nil => true
  delegate :read_announcements, :to => :user_profile, :allow_nil => true
  delegate :unread_announcements, :to => :user_profile, :allow_nil => true
  delegate :recent_unread_announcements, :to => :user_profile, :allow_nill => true
  delegate :available_character_proxies, :to => :user_profile, :allow_nil => true
  delegate :has_seen?, :to => :user_profile, :allow_nil => true
  delegate :default_character_proxy_for_a_game, :to => :user_profile, :allow_nil => true
  delegate :is_member?, :to => :user_profile, :allow_nil => true
  delegate :application_pending?, :to => :user_profile, :allow_nil => true

###
# Validators
###
  validates_associated :user_profile, :unless => Proc.new { |user| user.user_profile.nil? }

  validates :email,
      :uniqueness => true,
      :length => { :within => 5..128 },
      :format => { :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i }

  validates :password,
      :confirmation => true,
      :length => { :within => 8..30 },
      :presence => true,
      :format => {
        :with => %r{^(.*)([a-z][A-Z]|[a-z][\d]|[a-z][\W]|[A-Z][a-z]|[A-Z][\d]|[A-Z][\W]|[\d][a-z]|[\d][A-Z]|[\d][\W]|[\W][a-z]|[\W][A-Z]|[\W][\d])(.*)$},
        :message => "Must contain at least 2 of the following: lowercase letter, uppercase letter, number and punctuation symbols."
      },
      :if => :password_required?

  validates :accepted_current_terms_of_service,
      :acceptance => {:accept => true}
  validates :accepted_current_privacy_policy,
      :acceptance => {:accept => true}
  validates :date_of_birth, :presence => true

  validate :at_least_13_years_old

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
    User.update_all(:force_logout => true)
  end

  # This will reset all passwords for non disabled users.
  def self.reset_all_passwords
    begin
      User.find_each(:conditions => ['is_admin_disabled == ? AND is_user_disabled == ?', false, false]) do |record|
        random_password = User.send(:generate_token, 'encrypted_password').slice(0, 8)
        record.password = random_password
        record.reset_password_token = User.reset_password_token
        record.reset_password_sent_at = Time.now
        record.save
        UserMailer.all_password_reset(record, random_password).deliver
      end
    rescue Exception => e
      logger.error "Error Resetting All Passwords: #{e.message}"
      redirect_to :action => :index, :alert => "Error resetting all passwords."
      return
    end
  end

###
# Instance Methods
###

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
    self.password = random_password
    self.reset_password_token = User.reset_password_token
    self.reset_password_sent_at = Time.now
    self.save!
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
        self.community_profiles.clear
        self.owned_communities.clear
      end
      return success
    else
      return false
    end
  end

  # Used by the admin panel to disable a user.
  def disable_by_admin
    if self.update_attribute(:admin_disabled_at, Time.now)
      self.community_profiles.clear
      self.owned_communities.clear
    end  
  end

  # User by the admin panel to reinstate a user. This will set both is_admin_disabled and is_user_disabled to false.
  def reinstate
    self.update_attribute(:admin_disabled_at, nil)
    self.update_attribute(:user_disabled_at, nil)
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
        self.date_of_birth = Date.new(self.birth_year.to_i,self.birth_month.to_i,self.birth_day.to_i)
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
    errors.add(:date_of_birth, "you must be 13 years of age to use this service") if !self.date_of_birth? or 13.years.ago < self.date_of_birth
  end
end





# == Schema Information
#
# Table name: users
#
#  id                                :integer         not null, primary key
#  email                             :string(255)     default(""), not null
#  encrypted_password                :string(128)     default(""), not null
#  reset_password_token              :string(255)
#  reset_password_sent_at            :datetime
#  remember_created_at               :datetime
#  sign_in_count                     :integer         default(0)
#  current_sign_in_at                :datetime
#  last_sign_in_at                   :datetime
#  current_sign_in_ip                :string(255)
#  last_sign_in_ip                   :string(255)
#  confirmation_token                :string(255)
#  confirmed_at                      :datetime
#  confirmation_sent_at              :datetime
#  failed_attempts                   :integer         default(0)
#  unlock_token                      :string(255)
#  locked_at                         :datetime
#  created_at                        :datetime
#  updated_at                        :datetime
#  accepted_current_terms_of_service :boolean         default(FALSE)
#  accepted_current_privacy_policy   :boolean         default(FALSE)
#  force_logout                      :boolean         default(FALSE)
#  date_of_birth                     :date
#  user_disabled_at                  :datetime
#  admin_disabled_at                 :datetime
#

