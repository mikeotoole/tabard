# == Schema Information
#
# Table name: communities
#
#  id                          :integer         not null, primary key
#  name                        :string(255)
#  slogan                      :string(255)
#  accepting_members           :boolean         default(TRUE)
#  email_notice_on_application :boolean         default(TRUE)
#  subdomain                   :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#

require 'spec_helper'

describe Community do
  let(:community) { create(:community) }

  it "should create a new instance given valid attributes" do
    community.should be_valid
  end

  describe "name" do
    it "should be required" do
      build(:community, :name => nil).should_not be_valid
    end
    
    it "should accept valid format" do
      valid_names = %w{ OMGLOLOLOLOL My\ Community My-Community Community1 } # TESTING Valid community names for testing.
      valid_names.each do |name|
        build(:community, :name => name).should be_valid
      end
    end
    
    it "should reject invalid format" do
      invalid_names = %w{ 1212312&^*&^ #1Community My\ #1\ Community @TopComm } # TESTING Invalid community names for testing.
      invalid_names.each do |name|
        build(:community, :name => name).should_not be_valid
      end
    end  
    
    it "should reject excluded values" do
      excluded_names = %w{ www wwW wWw wWW Www WwW WWw WWW }
      excluded_names.each do |name|
        build(:community, :name => name).should_not be_valid
      end
    end
    
    it "should not be editable" do
      old_name = community.name
      community.update_attributes(:name => "ChangedName")
      community.name.should == old_name
    end    
  end

  describe "slogan" do
    it "should be required" do
      build(:community, :slogan => nil).should_not be_valid
    end
  end
  
  describe "subdomain" do
    it "should be created on save" do
      good_name_subdomain_hash = Hash[ "ALLUPPERCASENAME", "alluppercasename", "with space", "withspace", "with-dash", "withdash", "withnumber1", 'withnumber1'] # TESTING Valid community subdomain hash
  
      good_name_subdomain_hash.each do |name, subdomain|
        create(:community, :name => name).subdomain.should eq(subdomain)
      end
    end

    it "should be unique" do
      good_name_pairs_hash = Hash[ "OMGLOLOLOLOL", "MyCommunity", "My-Community", "Community1"] # TESTING Valid community pairs
      bad_name_pairs_hash = Hash[ "OMGLOLOLOLOL", "omglolololol", "My-Community", "My Community"] # TESTING Invalid community pairs
  
      good_name_pairs_hash.each  do |firstName, secondName|
        c = create(:community, :name => firstName)
        c.should be_valid
        build(:community, :name => secondName).should be_valid
        c.delete.should be_valid
      end
  
      bad_name_pairs_hash.each  do |firstName, secondName|
        c = create(:community, :name => firstName)
        c.should be_valid
        build(:community, :name => secondName).should_not be_valid
        c.delete.should be_valid
      end
    end
  end

  it "should be accepting members by default" do
    community.accepting_members.should be_true
  end

  it "should email on application by default" do
    community.email_notice_on_application.should be_true
  end
end

