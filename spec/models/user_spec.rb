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
#  user_active            :boolean         default(TRUE)
#  force_logout           :boolean         default(FALSE)
#

require 'spec_helper'

describe User do
  let(:user) { create(:user) }

  it "should create a new instance given valid attributes" do
    user.should be_valid
  end
  
  it "should setup billy using factory" do
    b = create(:billy)
    b.first_name.should eq("Robo")
    b.last_name.should eq("Billy")
    b.user_profile.character_proxies.size.should eq(CharacterProxy.all.count)
    b.user_profile.characters.size.should eq(b.user_profile.character_proxies.size)
  end
  
  describe "email address" do
    it "should be required" do
      build(:user, :email => nil).should_not be_valid
    end
  
    it "should accept valid format and length" do
      ok_emails = %w{ a@b.us vaild@email.com } # TESTING Valid emails for testing.
      ok_emails.each do |email|
        user = build(:user, :email => email).should be_valid
      end
    end
  
    it "should reject invalid format" do
      bad_emails = %w{ not_a_email no_domain@.com no_com@me } # TESTING Invalid emails for testing.
      bad_emails.each do |email|
        build(:user, :email => email).should_not be_valid
      end
      build(:user, :email => "").should_not be_valid
    end
  
    it "should reject duplicate" do
      user_with_duplicate_email = build(:user, :email => user.email)
      user_with_duplicate_email.should_not be_valid
      user_with_duplicate_email.errors[:email].join('; ').should eq(I18n.translate('activerecord.error.message.taken'))
    end
  
    it "should reject identical up to case" do
      build(:user, :email => user.email.upcase).should_not be_valid
    end  
  end

  describe "password" do
    it "should be an attribute" do
      user.should respond_to(:password)
    end

    it "confirmation should be an attribute" do
      user.should respond_to(:password_confirmation)
    end
    
    it "should not change to blank on update" do
      old_password = user.encrypted_password
      user.update_attributes(:password => "")
      user.encrypted_password.should eq(old_password)
      user.should be_valid
    end
    
    it "should be required" do
      build(:user, :password => "", :password_confirmation => "").should_not be_valid
    end

    it "should have matching password confirmation" do
      build(:user, :password_confirmation => "invalid").should_not be_valid
    end

    it "should reject short values" do
      short = "a" * 5
      build(:user, :password => short, :password_confirmation => short).should_not be_valid
    end

    it "should accept valid format" do
      ok_passwords = %w{ p@ssword Password! #password !password @password 2password p4ssword Password pAssword l0ngP@ssword 1111111@ @1111111 1111$111 11111111P P1111111 p1111111 PPPPPPPP@ } # TESTING Valid passwords for testing.
      ok_passwords.each do |password|
        build(:user, :password => password, :password_confirmation => password).should be_valid
      end
    end

    it "should reject invalid format" do
      bad_passwords = %w{ password 11111111 PASSWORD !!!!!!!! short OMFINGGthispasswordiswaytoolongtobevalid } # TESTING Invalid passwords for testing.
      bad_passwords.each do |password|
        build(:user, :password => password, :password_confirmation => password).should_not be_valid
      end
    end
  end

  describe "encrypted password" do
    before(:each) do
      @user = create(:user)
    end

    it "should be an attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should be set" do
      @user.encrypted_password.should_not be_blank
    end
  end
end
