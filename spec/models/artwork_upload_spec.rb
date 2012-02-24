# == Schema Information
#
# Table name: artwork_uploads
#
#  id               :integer         not null, primary key
#  email            :string(255)
#  attribution_name :string(255)
#  attribution_url  :string(255)
#  artwork_image    :string(255)
#  document_id      :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe ArtworkUpload do
  let(:artwork_upload) { create(:artwork_upload) }

  it "should create a new instance given valid attributes" do
    artwork_upload.should be_valid
  end
  
  describe "email address" do
    it "should be required" do
      build(:artwork_upload, :email => nil).should_not be_valid
    end
  
    it "should accept valid format and length" do
      ok_emails = %w{ a@b.us vaild@email.com } # TESTING Valid emails for testing.
      ok_emails.each do |email|
        user = build(:artwork_upload, :email => email).should be_valid
      end
    end
  
    it "should reject invalid format" do
      bad_emails = %w{ not_a_email no_domain@.com no_com@me } # TESTING Invalid emails for testing.
      bad_emails.each do |email|
        build(:artwork_upload, :email => email).should_not be_valid
      end
      build(:artwork_upload, :email => "").should_not be_valid
    end 
  end
  
  it "should require artwork_image" do
    build(:artwork_upload, :artwork_image => nil).should_not be_valid
  end
  
  it "should require document" do
    create(:artwork_agreement)
    build(:artwork_upload, :document => nil).should_not be_valid
  end
  
  it "should require acceptance of accepted_current_artwork_agreement" do
    build(:artwork_upload, :accepted_current_artwork_agreement => "0").should_not be_valid
  end
  
  it "should require document is current artwork_agreement" do
    doc = create(:artwork_agreement)
    create(:artwork_agreement)
    build(:artwork_upload, :document => doc).should_not be_valid
  end
  
  it "should require attribution_name if attribution_url is present" do
    build(:artwork_upload, :attribution_name => nil).should_not be_valid
  end
  
  it "should require attribution_url if attribution_name is present" do
    build(:artwork_upload, :attribution_url => nil).should_not be_valid
  end
  
  it "should not require attribution_url and attribution_name if both are not given" do
    build(:artwork_upload, :attribution_url => nil, :attribution_name => nil).should be_valid
  end
end
