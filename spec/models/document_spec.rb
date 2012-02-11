# == Schema Information
#
# Table name: documents
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  body         :text
#  created_at   :datetime
#  updated_at   :datetime
#  version      :integer
#  is_published :boolean         default(FALSE)
#

require 'spec_helper'

describe Document do
  let(:document) { create(:terms_of_service) }
  let(:unpublished) { create(:terms_of_service, :is_published => false) }

  it "should create a new instance given valid attributes" do
    document.should be_valid
  end
  
  describe "it should validate" do
    it "presence of body" do
      build(:terms_of_service, :body => nil).valid?.should be_false
    end
    
    it "presence of type" do
      build(:terms_of_service, :type => nil).valid?.should be_false
    end
    
    it "type is included in VALID_TYPES" do
      build(:terms_of_service, :type => "NotValid").valid?.should be_false
    end
    
    it "uniqueness of version within scope" do
      build(:terms_of_service, :version => document.version).valid?.should be_false
    end
  end
  
  describe "after save" do
    it "of terms_of_service should set all users accepted_current_terms_of_service to false" do
      DefaultObjects.user.accepted_current_terms_of_service.should be_true
      document
      User.find(DefaultObjects.user).accepted_current_terms_of_service.should be_false
    end
    
    it "of terms_of_service should not set all users accepted_current_privacy_policy to false" do
      DefaultObjects.user.accepted_current_terms_of_service.should be_true
      DefaultObjects.user.accepted_current_privacy_policy.should be_true
      document
      User.find(DefaultObjects.user).accepted_current_terms_of_service.should be_false
      User.find(DefaultObjects.user).accepted_current_privacy_policy.should be_true
    end
    
    it "of privacy_policy should set all users accepted_current_privacy_policy to false" do
      DefaultObjects.user.accepted_current_privacy_policy.should be_true
      create(:privacy_policy)
      User.find(DefaultObjects.user).accepted_current_privacy_policy.should be_false
    end
    
    it "of privacy_policy should not set all users accepted_current_terms_of_service to false" do
      DefaultObjects.user.accepted_current_terms_of_service.should be_true
      DefaultObjects.user.accepted_current_privacy_policy.should be_true
      create(:privacy_policy)
      User.find(DefaultObjects.user).accepted_current_terms_of_service.should be_true
      User.find(DefaultObjects.user).accepted_current_privacy_policy.should be_false
    end
  end
  
  it "should not allow updating a document with is_published equal to true" do
    org_body = document.body
    document.update_attributes(:body => "New Body").should be_false
    document.errors.first.should include("This document has been published and can't be changed.")
    Document.find(document).body.should eql org_body
  end  
    
  it "should allow updating a document with is_published equal to false" do
    unpublished.is_published.should be_false
    unpublished.update_attributes(:body => "New Body").should be_true
    Document.find(unpublished).body.should eql "New Body"
  end
  
  describe "title" do
    it "should return a title with spaces" do
      create(:terms_of_service).title.should eql "Terms of Service and User Agreement"
      create(:privacy_policy).title.should eql "Privacy Policy"
    end
  end
  
  describe "acceptance_count" do
    it "should return the valid number of times document has been accepted" do
      DefaultObjects.user.document_acceptances.count.should eql 2
      DefaultObjects.user.accepted_documents.first.acceptance_count.should eql User.all.count
    end
  end
end
