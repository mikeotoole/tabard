class AdminUser < ActiveRecord::Base
  ROLES = %w[moderator admin superadmin]
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role
  
  after_create :notify_user

###
# Validators
###
  validates :role,
            :presence => true,
            :inclusion => { :in => ROLES, :message => "%{value} is not currently a supported role" }

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
  
###
# Public Methods
###
  def password_required?
    (new_record? ? false : super) || self.password.present?
  end
  
###
# Protected Methods
###
protected
  
  ###
  # notify user and send password setup instructions.
  ###
  def notify_user
    random_password = AdminUser.send(:generate_token, 'encrypted_password').slice(0, 8)
    self.password = random_password  
    self.reset_password_token = AdminUser.reset_password_token
    self.reset_password_sent_at = Time.now    
    self.save
    UserMailer.setup_admin(AdminUser.find(self), random_password).deliver # TODO Mike, Why is AdminUser.find(self) required?
  end
end



# == Schema Information
#
# Table name: admin_users
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
#  created_at             :datetime
#  updated_at             :datetime
#  role                   :string(255)
#  failed_attempts        :integer         default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#

