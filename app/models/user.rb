###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This is the user class.
###
# This class is configured to work with devise to provide us authentication capabilities.
class User < ActiveRecord::Base
  # TODO We need to configure config/enviroments/production.rb with the mailer info.

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
  attr_accessible :email, :password, :password_confirmation, :remember_me

  ###
  # Validators
  ###
  validates :email,
      :uniqueness => true,
      :length => { :within => 5..128 },
      :format => { :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i }
  validates :password,
      :confirmation => true,
      :length => { :within => 8..30 },
      :presence => true,
      :format => {
        :with => %r{^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).*$},
        #:with => %r{^([:digit:]+[:lower:]+.*|[:digit:]+[:upper:]+.*|[:digit:]+[:punct:]+.*)|([:lower:]+[:digit:]+.*|[:lower:]+[:upper:]+.*|[:lower:]+[:punct:]+.*)|([:upper:]+[:digit:]+.*|[:upper:]+[:lower:]+.*|[:upper:]+[:punct:]+.*)|([:punct:]+[:digit:]+.*|[:punct:]+[:lower:]+.*|[:punct:]+[:upper:]+.*)$},
        :message => "Must contain at least 2 of the following: lowercase letter, uppercase letter, number and punctuation symbols."
      },
      :if => :password_required?

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
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  failed_attempts        :integer         default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#

