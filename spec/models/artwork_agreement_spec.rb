# == Schema Information
#
# Table name: documents
#
#  id           :integer          not null, primary key
#  type         :string(255)
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  version      :integer
#  is_published :boolean          default(FALSE)
#

require 'spec_helper'

describe ArtworkAgreement do
  let(:document) { create(:artwork_agreement) }
  let(:unpublished) { create(:artwork_agreement, :is_published => false) }
  
  describe "current" do
    it "should return the Artwork Agreement with highest version and marked as is_published" do
      create(:artwork_agreement)
      document
      ArtworkAgreement.all.count.should eql 2
      ArtworkAgreement.first.should eql document
      document.version.should > ArtworkAgreement.last.version
      document.is_published.should be_true
      ArtworkAgreement.current.should eql document
    end

     it "should not return the Privacy Policy with highest version and not marked as is_published" do
      document.version.should < unpublished.version
      ArtworkAgreement.current.should eql document
    end     
  end

  describe "is_current?" do
    it "should return true if current Artwork Agreement" do
      document
      ArtworkAgreement.current.should eql document
      document.is_current?.should be_true
    end
    
    it "should return false if not current Artwork Agreement" do
      document.version.should < unpublished.version
      ArtworkAgreement.current.should eql document
      unpublished.is_current?.should be_false
    end
  end
end
