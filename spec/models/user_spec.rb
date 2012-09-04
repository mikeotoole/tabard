# == Schema Information
#
# Table name: users
#
#  id                                :integer          not null, primary key
#  email                             :string(255)      default(""), not null
#  encrypted_password                :string(255)      default(""), not null
#  reset_password_token              :string(255)
#  reset_password_sent_at            :datetime
#  remember_created_at               :datetime
#  confirmation_token                :string(255)
#  confirmed_at                      :datetime
#  confirmation_sent_at              :datetime
#  unconfirmed_email                 :string(255)
#  failed_attempts                   :integer          default(0)
#  unlock_token                      :string(255)
#  locked_at                         :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  accepted_current_terms_of_service :boolean          default(FALSE)
#  accepted_current_privacy_policy   :boolean          default(FALSE)
#  force_logout                      :boolean          default(FALSE)
#  date_of_birth                     :date
#  user_disabled_at                  :datetime
#  admin_disabled_at                 :datetime
#  user_profile_id                   :integer
#  time_zone                         :integer          default(-8)
#  is_email_on_message               :boolean          default(TRUE)
#  is_email_on_announcement          :boolean          default(TRUE)
#  stripe_customer_token             :string(255)
#  stripe_subscription_date          :date
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
  
  it "should require a user_profile" do
    build(:user, :user_profile_attributes => {}).should_not be_valid
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
  describe "has_accepted_current_terms_of_service?" do
    before(:each) do
      @user = create(:user)
      @current_version = create(:terms_of_service)
      @current_version.should eq TermsOfService.current
    end
    it "returns false if not accepted current terms of service" do
      @user.has_accepted_current_terms_of_service?.should be_false
      @user.accepted_documents.include?(@current_version).should be_false
    end
    it "returns true if accepted current terms of service" do
      @user.accepted_documents << @current_version
      @user = User.find(@user)
      @user.accepted_documents.include?(@current_version).should be_true
      @user.has_accepted_current_terms_of_service?.should be_true
    end
  end
  describe "has_accepted_current_privacy_policy?" do
    before(:each) do
      @user = create(:user)
      @current_version = create(:privacy_policy)
      @current_version.should eq PrivacyPolicy.current
    end
    it "returns false if not accepted current privacy policy" do
      @user.has_accepted_current_privacy_policy?.should be_false
      @user.accepted_documents.include?(@current_version).should be_false
    end
    it "returns true if accepted current privacy policy" do
      @user.accepted_documents << @current_version
      @user = User.find(@user)
      @user.accepted_documents.include?(@current_version).should be_true
      @user.has_accepted_current_privacy_policy?.should be_true
    end
  end
  describe "date_of_birth" do
    it "should not be valid for an 8 year old" do
      build(:user, :date_of_birth => (Time.zone.now - 8.years).to_date).should_not be_valid
    end
    it "should be valid for a 13 year old" do
      build(:user, :date_of_birth => (Time.zone.now - 13.years).to_date).should be_valid
    end
    it "should not be valid for an 13 year plus one day old" do
      build(:user, :date_of_birth => (Time.zone.now - 13.years + 1.day).to_date).should_not be_valid
    end
    it "should be valid for an 27 year old" do
      build(:user, :date_of_birth => (Time.zone.now - 27.years).to_date).should be_valid
    end
  end
  
  describe "is_disabled?" do
    it "should return false if both admin_disabled_at and user_disabled_at are nil" do
      user.admin_disabled_at.should be_nil
      user.user_disabled_at.should be_nil
      user.is_disabled?.should be_false
    end
    
    it "should return true if admin_disabled_at is not nil" do
      user.update_column(:admin_disabled_at, Time.now)
      user.reload.admin_disabled_at.should_not be_nil
      user.is_disabled?.should be_true
    end
    
    it "should return true if user_disabled_at is not nil" do
      user.update_column(:user_disabled_at, Time.now)
      user.reload.user_disabled_at.should_not be_nil
      user.is_disabled?.should be_true
    end
  end
  
  describe "disable_by_user" do
    describe "with correct password" do
      it "should return true" do
        user.disable_by_user({:user => {:current_password => user.password}}).should be_true
      end
      
      it "should set user_disabled_at" do
        user.user_disabled_at.should be_nil
        user.disable_by_user({:user => {:current_password => user.password}}).should be_true
        user.reload.user_disabled_at.should_not be_nil
      end
      
      it "should remove user from communities" do
        user = DefaultObjects.user
        community_profiles = user.community_profiles.all
        user.disable_by_user({:user => {:current_password => user.password}}).should be_true
        
        community_profiles.should_not be_empty
        community_profiles.each do |community_profile|
          CommunityProfile.exists?(community_profile).should be_false
        end
      end
      
      it "should remove user's owned communities" do
        user = DefaultObjects.community_admin
        owned_communities = user.owned_communities.all
        user.disable_by_user({:user => {:current_password => "Password"}}).should be_true
        owned_communities.should_not be_empty
        owned_communities.each do |owned_community|
          Community.exists?(owned_community).should be_false
        end
      end
    end
    
    describe "with incorrect password" do
      it "should return false" do
        user.disable_by_user({:user => {:current_password => "Not Password"}}).should be_false
      end
      
      it "should not set user_disabled_at" do
        user.user_disabled_at.should be_nil
        user.disable_by_user({:user => {:current_password => "Not Password"}}).should be_false
        user.reload.user_disabled_at.should be_nil
      end
      
      it "should not remove user from communities" do
        user = DefaultObjects.user
        community_profiles = user.community_profiles.all
        user.disable_by_user({:user => {:current_password => "Not Password"}}).should be_false
        
        community_profiles.should_not be_empty
        community_profiles.each do |community_profile|
          CommunityProfile.exists?(community_profile).should be_true
        end
      end
      
      it "should not remove user's owned communities" do
        user = DefaultObjects.community_admin
        owned_communities = user.owned_communities.all
        user.disable_by_user({:user => {:current_password => "Not Password"}}).should be_false
        owned_communities.should_not be_empty
        owned_communities.each do |owned_community|
          Community.exists?(owned_community).should be_true
        end
      end
    end
  end
  
  describe "disable_by_admin" do
    it "should set admin_disabled_at" do
      user.admin_disabled_at.should be_nil
      user.disable_by_admin
      user.reload.admin_disabled_at.should_not be_nil
    end
    
    it "should remove user from communities" do
      user = DefaultObjects.user
      community_profiles = user.community_profiles.all
      user.disable_by_admin
      
      community_profiles.should_not be_empty
      community_profiles.each do |community_profile|
        CommunityProfile.exists?(community_profile).should be_false
      end
    end
    
    it "should remove user's owned communities" do
      user = DefaultObjects.community_admin
      owned_communities = user.owned_communities.all
      user.disable_by_admin
      owned_communities.should_not be_empty
      owned_communities.each do |owned_community|
        Community.exists?(owned_community).should be_false
      end
    end
  end
  
  describe "remove_from_all_communities" do
    it "should remove user from communities" do
      user = DefaultObjects.user
      community_profiles = user.community_profiles.all
      user.remove_from_all_communities
      
      community_profiles.should_not be_empty
      community_profiles.each do |community_profile|
        CommunityProfile.exists?(community_profile).should be_false
      end
    end
    
    it "should remove user's owned communities" do
      user = DefaultObjects.community_admin
      owned_communities = user.owned_communities.all
      user.remove_from_all_communities
      owned_communities.should_not be_empty
      owned_communities.each do |owned_community|
        Community.exists?(owned_community).should be_false
      end
    end
  end
  
  describe "reinstate_by_admin" do
    it "should set admin_disabled_at to nil" do
      user.update_column(:admin_disabled_at, Time.now)
      user.reload.admin_disabled_at.should_not be_nil
      user.reinstate_by_admin
      user.reload.admin_disabled_at.should be_nil
    end
    
    it "should set user_disabled_at to nil" do
      user.update_column(:user_disabled_at, Time.now)
      user.reload.user_disabled_at.should_not be_nil
      user.reinstate_by_admin
      user.reload.user_disabled_at.should be_nil
    end
  end
  
  describe "reinstate_by_user" do
    it "should return false if user is not disabled by user" do
      user.reinstate_by_user.should be_false
    end
    
    it "should set reset_password_token" do
      user.update_column(:user_disabled_at, Time.now)
      user.reload.user_disabled_at.should_not be_nil
      user.reset_password_token.should be_nil
      user.reinstate_by_user.should be_true
      user.reload.reset_password_token.should_not be_nil
    end
    
    it "should set reset_password_sent_at" do
      user.update_column(:user_disabled_at, Time.now)
      user.reload.user_disabled_at.should_not be_nil
      user.reset_password_sent_at.should be_nil
      user.reinstate_by_user.should be_true
      user.reload.reset_password_sent_at.should_not be_nil
    end
  end
  
  describe "destroy" do
    it "should delete user" do
      user.destroy
      User.exists?(user).should be_false
    end
    
    it "should delete user's user_profile" do
      user_profile = create(:user_profile)
      user = user_profile.user
      
      user.destroy
      UserProfile.exists?(user_profile).should be_false
    end
    
    it "should delete user's document_acceptances" do
      document_acceptances = user.document_acceptances.all
      user.destroy
      document_acceptances.count.should eq 2
      document_acceptances.each do |document_acceptance|
        DocumentAcceptance.exists?(document_acceptance).should be_false
      end
    end
  end

  describe "nuke" do
    it "should delete user" do
      user.nuke
      User.exists?(user).should be_false
    end
    
    it "should delete user's user_profile" do
      user_profile = create(:user_profile)
      user = user_profile.user
      
      user.nuke
      UserProfile.exists?(user_profile).should be_false
    end
    
    it "should call 'nuke' on user's user_profile" do
      user_profile = create(:user_profile)
      user = user_profile.user
      
      user_profile.should_receive(:nuke)
      user.nuke
    end
    
    it "should delete user's document_acceptances" do
      document_acceptances = user.document_acceptances.all
      user.nuke
      document_acceptances.count.should eq 2
      document_acceptances.each do |document_acceptance|
        DocumentAcceptance.exists?(document_acceptance).should be_false
      end
    end
  end
end
