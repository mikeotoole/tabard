require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  
  validates :email, :uniqueness => true,
                    :length => { :within => 5..50 },
                    :format => { :with => /^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i }
  validates :password, :confirmation => true, 
                    :length => { :within => 4..20 },
                    :presence => true, 
                    :if => :password_required?
                    
  has_many :game_profiles
  has_one :user_profile
  
  has_and_belongs_to_many :roles
  
  before_save :encrypt_new_password
  
  def name
    user_profile.name
  end
  
  def self.authenticate(email, password) 
    user = find_by_email(email) 
    return user if user && user.authenticated?(password)
  end
  
  def authenticated?(password) 
    self.hashed_password == encrypt(password)
  end
  
  def can_show(system_resource_name)
    self.roles.each do |role|
      role.permissions.each do |permission|
        if permission.permissionable.is_a? SystemResource
          if (permission.permissionable.name == system_resource_name) && (permission.show_p == true)
            return true
          end
        end
      end
    end
    false
  end
  
  def can_create(system_resource_name)
    self.roles.each do |role|
      role.permissions.each do |permission|
        if permission.permissionable.is_a? SystemResource
          if permission.permissionable.name == system_resource_name && permission.create_p
            return true
          end
        end
      end
    end
    false
  end
  
  def can_update(system_resource_name)
    self.roles.each do |role|
      role.permissions.each do |permission|
        if permission.permissionable.is_a? SystemResource
          if permission.permissionable.name == system_resource_name && permission.update_p
            return true
          end
        end
      end
    end
    false
  end
  
  def can_delete(system_resource_name)
    self.roles.each do |role|
      role.permissions.each do |permission|
        if permission.permissionable.is_a? SystemResource
          if permission.permissionable.name == system_resource_name && permission.delete_p
            return true
          end
        end
      end
    end
    false
  end
  
  protected 
    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password) 
    end
  
    def password_required? 
      hashed_password.blank? || password.present?
    end
    def encrypt(string) 
      Digest::SHA1.hexdigest(string)
    end
end
