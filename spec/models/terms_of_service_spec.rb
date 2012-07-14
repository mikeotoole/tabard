# == Schema Information
#
# Table name: documents
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  body         :text
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  version      :integer
#  is_published :boolean         default(FALSE)
#

require 'spec_helper'

describe TermsOfService do
  let(:document) { create(:terms_of_service) }
  let(:unpublished) { create(:terms_of_service, :is_published => false) }
  
  describe "current" do
    it "should return the Terms Of Service with highest version and marked as is_published" do
      document
      TermsOfService.all.count.should eql 2
      TermsOfService.first.should eql document
      document.version.should > TermsOfService.last.version
      document.is_published.should be_true
      TermsOfService.current.should eql document
    end
     it "should not return the Terms Of Service with highest version and not marked as is_published" do
      document.version.should < unpublished.version
      TermsOfService.current.should eql document
    end     
  end

  describe "is_current?" do
    it "should return true if current Terms Of Service" do
      document
      TermsOfService.current.should eql document
      document.is_current?.should be_true
    end
    
    it "should return false if not current Terms Of Service" do
      document.version.should < unpublished.version
      TermsOfService.current.should eql document
      unpublished.is_current?.should be_false
    end
  end
end
