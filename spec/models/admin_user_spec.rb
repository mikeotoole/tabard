# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
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

require 'spec_helper'

describe AdminUser do
  let(:superadmin) { create(:admin_user) }   

  it "should create a new instance given valid attributes" do
    build(:admin_user).should be_valid
  end
  
  describe "email address" do
    it "should be required" do
      build(:admin_user, :email => nil).should_not be_valid
    end
  
    it "should accept valid format and length" do
      ok_emails = %w{ a@b.us vaild@email.com } # TESTING Valid emails for testing.
      ok_emails.each do |email|
        user = build(:admin_user, :email => email).should be_valid
      end
    end
  
    it "should reject invalid format" do
      bad_emails = %w{ not_a_email no_domain@.com no_com@me } # TESTING Invalid emails for testing.
      bad_emails.each do |email|
        build(:admin_user, :email => email).should_not be_valid
      end
      build(:admin_user, :email => "").should_not be_valid
    end
  
    it "should reject duplicate" do
      user_with_duplicate_email = build(:admin_user, :email => superadmin.email)
      user_with_duplicate_email.should_not be_valid
      user_with_duplicate_email.errors[:email].first.should eq(I18n.translate('activerecord.error.message.taken'))
    end
  
    it "should reject identical up to case" do
      build(:admin_user, :email => superadmin.email.upcase).should_not be_valid
    end  
  end

  describe "password" do
    it "should be an attribute" do
      superadmin.should respond_to(:password)
    end

    it "confirmation should be an attribute" do
      superadmin.should respond_to(:password_confirmation)
    end
    
    it "should not be required for new AdminUser" do
      build(:admin_user, :password => nil, :password_confirmation => nil).should be_valid
    end
    
    it "should not change to blank on update" do
      old_password = superadmin.encrypted_password
      superadmin.update_attributes(:password => "")
      superadmin.encrypted_password.should eq(old_password)
    end

    it "should have matching password confirmation" do
      build(:admin_user, :password => "notsame", :password_confirmation => "invalid").should_not be_valid
    end

    it "should reject short values" do
      short = "a" * 5
      build(:admin_user, :password => short, :password_confirmation => short).should_not be_valid
    end

    it "should accept valid format" do
      ok_passwords = %w{ p@ssword Password! #password !password @password 2password p4ssword Password pAssword l0ngP@ssword 1111111@ @1111111 1111$111 11111111P P1111111 p1111111 PPPPPPPP@ } # TESTING Valid passwords for testing.
      ok_passwords.each do |password|
        build(:admin_user, :password => password, :password_confirmation => password).should be_valid
      end
    end

    it "should reject invalid format" do
      bad_passwords = %w{ password 11111111 PASSWORD !!!!!!!! short OMFINGGthispasswordiswaytoolongtobevalid } # TESTING Invalid passwords for testing.
      bad_passwords.each do |password|
        build(:admin_user, :password => password, :password_confirmation => password).should_not be_valid
      end
    end
  end

  describe "encrypted password" do
    it "should be an attribute" do
      superadmin.should respond_to(:encrypted_password)
    end

    it "should be set" do
     superadmin.encrypted_password.should_not be_blank
    end
  end

  describe "role" do
    it "should be an attribute" do
      superadmin.should respond_to(:role)
    end
    
    it "should be required" do
      build(:admin_user, :role => nil).should_not be_valid
    end
    
    it "should accept valid values" do
      AdminUser::ROLES.each do |role|
        build(:admin_user, :role => role).should be_valid
      end
    end
    
    it "should reject invalid values" do
      bad_roles = %w{ adm super notvalid admin1 superadmin_ } # TESTING Invalid roles for testing.
      bad_roles.each do |role|
        build(:admin_user, :role => role).should_not be_valid
      end
    end
  end
end
