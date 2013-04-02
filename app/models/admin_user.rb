###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an AdminUser used for Admin Panel.
###
class AdminUser < ActiveRecord::Base
  validates_lengths_from_database except: [:email, :password, :avatar]
  # Array of valid roles.
  ROLES = %w[moderator admin superadmin]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable :recoverable
  devise :database_authenticatable, :trackable, :validatable, :lockable, :recoverable, :timeoutable, :async

  attr_accessor :validation_code

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :display_name, :avatar, :remove_avatar, :remote_avatar_url, :role

###
# Associations
###
  has_many :support_tickets, inverse_of: :admin_user
  has_many :support_comments, inverse_of: :admin_user

###
# Validators
###
  validates :role,
            presence: true,
            inclusion: { in: ROLES, message: "%{value} is not currently a supported role" }

  validates :email,
      uniqueness: true,
      length: { within: 5..128 },
      format: { with: %r{\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\Z}i }

  validates :password,
      confirmation: true,
      length: { within: 8..30 },
      presence: true,
      format: {
        with: %r{\A(.*)([a-z][A-Z]|[a-z][\d]|[a-z][\W]|[A-Z][a-z]|[A-Z][\d]|[A-Z][\W]|[\d][a-z]|[\d][A-Z]|[\d][\W]|[\W][a-z]|[\W][A-Z]|[\W][\d])(.*)\Z},
        message: "Must contain at least 2 of the following: lowercase letter, uppercase letter, number and punctuation symbols."
      },
      if: :password_required?

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

###
# Callbacks
###
  before_validation :assign_auth_secret, :on => :create


###
# Public Methods
###

###
# Class Methods
###
  # This will reset all passwords for admin users.
  def self.reset_all_passwords
    AdminUser.all.each do |user|
      AdminUser.delay.reset_admin_user_password(user.id)
    end
  end

  # This is a class method to reset a users password.
  def self.reset_admin_user_password(id)
    AdminUser.find(id).reset_password
  end

###
# Instance Methods
###
  # Will reset the admin users password.
  def reset_password
    random_password = AdminUser.send(:generate_token, 'encrypted_password').slice(0, 8)
    self.password = random_password if random_password
    self.password_confirmation = random_password if random_password
    self.reset_password_token = AdminUser.reset_password_token
    self.reset_password_sent_at = Time.now
    self.save(validate: false)
    UserMailer.password_reset(self, random_password).deliver
  end

  ###
  # This gives roles a hierarchy. e.g. admin has all moderator abilities.
  ###
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  ###
  # This method determines if the password is required. It is used to determine if password needs to be validated.
  # [Returns] False if this is a new record or calls devises password_required? or true if password is present.
  ###
  def password_required?
    (new_record? ? false : super) || self.password.present?
  end

  # Get the url for grcode used for multifactor auth setup.
  def google_authenticator_qrcode_url
    data = "otpauth://totp/#{ENV['BV_HOST_URL']}?secret=#{self.auth_secret}"
    data = Rack::Utils.escape(data)
    url = "https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=#{data}"
    return url
  end

  # Session will time out after 20 minutes of inactivity.
  def timeout_in
    20.minutes
  end


protected

  ###
  # _before_validation_
  #
  ###
  def assign_auth_secret
    self.auth_secret = ROTP::Base32.random_base32
  end
end

# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  display_name           :string(255)
#  avatar                 :string(255)
#  auth_secret            :string(255)
#

