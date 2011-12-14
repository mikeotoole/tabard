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

describe PrivacyPolicy do
  let(:document) { create(:privacy_policy) }
  let(:unpublished) { create(:privacy_policy, :is_published => false) }
  
  describe "current" do
    it "should return the Privacy Policy with highest version and marked as is_published" do
      document
      PrivacyPolicy.all.count.should eql 2
      PrivacyPolicy.first.should eql document
      document.version.should > PrivacyPolicy.last.version
      document.is_published.should be_true
      PrivacyPolicy.current.should eql document
    end
     it "should not return the Privacy Policy with highest version and not marked as is_published" do
      document.version.should < unpublished.version
      PrivacyPolicy.current.should eql document
    end     
  end

  describe "is_current?" do
    it "should return true if current Privacy Policy" do
      document
      PrivacyPolicy.current.should eql document
      document.is_current?.should be_true
    end
    
    it "should return false if not current Privacy Policy" do
      document.version.should < unpublished.version
      PrivacyPolicy.current.should eql document
      unpublished.is_current?.should be_false
    end
  end
end
