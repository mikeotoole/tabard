require 'spec_helper'

describe User do
  let(:user) { Factory.create(:user) }

  it "should create a new instance given valid attributes" do
    user.should be_valid
  end
  
  describe "email address" do
    it "should be required" do
      Factory.build(:user, :email => nil).should_not be_valid
    end
  
    it "should accept valid format and length" do
      ok_emails = %w{ a@b.us vaild@email.com } # TESTING Valid emails for testing.
      ok_emails.each do |email|
        user = Factory.build(:user, :email => email).should be_valid
      end
    end
  
    it "should reject invalid format" do
      bad_emails = %w{ not_a_email no_domain@.com no_com@me } # TESTING Invalid emails for testing.
      bad_emails.each do |email|
        Factory.build(:user, :email => email).should_not be_valid
      end
      Factory.build(:user, :email => "").should_not be_valid
    end
  
    it "should reject duplicate" do
      user_with_duplicate_email = Factory.build(:user, :email => user.email)
      user_with_duplicate_email.should_not be_valid
      user_with_duplicate_email.errors[:email].join('; ').should == I18n.translate('activerecord.error.message.taken')
    end
  
    it "should reject identical up to case" do
      Factory.build(:user, :email => user.email.upcase).should_not be_valid
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
      user.encrypted_password.should == old_password
      user.should be_valid
    end
    
    it "should be required" do
      Factory.build(:user, :password => "", :password_confirmation => "").should_not be_valid
    end

    it "should have matching password confirmation" do
      Factory.build(:user, :password_confirmation => "invalid").should_not be_valid
    end

    it "should reject short values" do
      short = "a" * 5
      Factory.build(:user, :password => short, :password_confirmation => short).should_not be_valid
    end

    it "should accept valid format" do
      ok_passwords = %w{ p@ssword Password! #password !password @password 2password p4ssword Password pAssword l0ngP@ssword 1111111@ @1111111 1111$111 11111111P P1111111 p1111111 PPPPPPPP@ } # TESTING Valid passwords for testing.
      ok_passwords.each do |password|
        Factory.build(:user, :password => password, :password_confirmation => password).should be_valid
      end
    end

    it "should reject invalid format" do
      bad_passwords = %w{ password 11111111 PASSWORD !!!!!!!! short OMFINGGthispasswordiswaytoolongtobevalid } # TESTING Invalid passwords for testing.
      bad_passwords.each do |password|
        Factory.build(:user, :password => password, :password_confirmation => password).should_not be_valid
      end
    end
  end

  describe "encrypted password" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should be an attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should be set" do
      @user.encrypted_password.should_not be_blank
    end
  end
end
