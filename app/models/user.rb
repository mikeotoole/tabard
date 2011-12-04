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
  # TODO Bryan/Joe We need to configure config/enviroments/production.rb with the mailer info. -JW
###
# Devise configuration information
###
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :lockable

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_profile_attributes, :user_profile,
    :accepted_current_terms_of_service, :accepted_current_privacy_policy, :user_disabled

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

###
# Public Methods
###

###
# Class Methods
###

  # This method returns a default guest user that is used to handle permissions
  def self.guest
    user = User.new
    user.build_user_profile
    return user
  end

  # This will set force_logout to true on all users.
  def self.force_active_users_to_sign_out
    User.update_all(:force_logout => true)
  end
  
  def self.reset_all_passwords
    begin
      User.find_each(:conditions => ['admin_disabled == ? AND user_disabled == ?', false, false]) do |record|
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
  #This method updates the acceptance of documents
  def update_document_acceptance
    self.accepted_documents << TermsOfService.current if self.accepted_current_terms_of_service and not has_accepted_current_terms_of_service?
    self.accepted_documents << PrivacyPolicy.current if self.accepted_current_privacy_policy and not has_accepted_current_privacy_policy?
  end

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
  # This method determines if the user is active. It is adding to the existing Devise method.
  # [Returns] True if this is an active user, otherwise false.
  ###
  def active_for_authentication?
    super and not self.disabled
  end

  ###
  # This method overrides the existing Devise method to check it account is disabled.
  # [Returns] :suspended if account is suspended otherwise it returns super's response.
  ###
  def inactive_message
    if self.admin_disabled
      :admin_disabled
    elsif self.user_disabled
      :user_disabled
    else
      super
    end
  end
  
  def disabled
    self.admin_disabled or self.user_disabled
  end
  
  def disable_by_user
    self.user_disabled = true
    self.user_disabled_at = Time.now
    self.community_profiles.delete
    self.owned_communities.clear
    self.save
  end
  
  def disable_by_admin
    self.admin_disabled = true
    self.admin_disabled_at = Time.now
    self.community_profiles.delete
    self.owned_communities.clear
    self.save
  end
  
  def reinstate
    self.admin_disabled = false
    self.admin_disabled_at = nil
    self.user_disabled = false
    self.user_disabled_at = nil
    self.save
  end
  
  def reset_password
    random_password = User.send(:generate_token, 'encrypted_password').slice(0, 8)
    user.password = random_password
    user.reset_password_token = User.reset_password_token
    user.reset_password_sent_at = Time.now
    user.save
    UserMailer.password_reset(user, random_password).deliver
  end

###
# Protected Methods
###
protected

  ###
  # This method determines if the password is required. It is used to determine if password needs to be validated.
  # [Returns] True if this is a new record or if password is present, otherwise false.
  ###
  def password_required?
    self.new_record? || self.password.present?
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
#  admin_disabled                    :boolean         default(FALSE)
#  user_disabled                     :boolean         default(FALSE)
#  user_disabled_at                  :datetime
#  admin_disabled_at                 :datetime
#

