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
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_profile_attributes, :user_profile

###
# Associations
###
  has_one :user_profile, :inverse_of => :user
  has_many :document_acceptances
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
  delegate :available_character_proxies, :to => :user_profile, :allow_nil => true
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
  # This method returns a default guest user that is used to handle permissions
  def self.guest
    user = User.new
    user.build_user_profile
    return user
  end

  #This method updates the acceptance of documents
  def update_document_acceptance
    self.document_acceptances.create(:user => self, :document => current_terms_of_service) if self.accepted_current_terms_of_service and not has_accepted_current_terms_of_service?
    self.document_acceptances.create(:user => self, :document => current_privacy_policy) if self.accepted_current_privacy_policy and not has_accepted_current_privacy_policy?
  end

  #This method finds the most recent version of the terms of service
  def current_terms_of_service
    TermsOfService.first
  end
  #This method checks to see if the user has accepted the most recent version of the Terms of Service.
  def has_accepted_current_terms_of_service?
    document_acceptances.include?(current_terms_of_service)
  end
  #This method finds the most recent version of the terms of service
  def current_privacy_policy
    PrivacyPolicy.first
  end
  #This method checks to see if the user has accepted the most recent version of the Privacy Policy.
  def has_accepted_current_privacy_policy?
    document_acceptances.include?(current_privacy_policy)
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
#

