require 'spec_helper'

describe Community do
  let(:community) { Factory.create(:community) }

  it "should create a new instance given valid attributes" do
    community.should be_valid
  end

  it "should require a name" do
    Factory.build(:community, :name => nil).should_not be_valid
  end

  it "should require a slogan" do
    Factory.build(:community, :slogan => nil).should_not be_valid
  end

  it "should require a label" do
    Factory.build(:community, :label => nil).should_not be_valid
  end

  it "should be accepting members by default" do
    community.accepting_members.should == true
  end

  it "should email on application by default" do
    community.email_notice_on_application.should == true
  end

  it "should accept valid name" do
    valid_names = %w{ OMGLOLOLOLOL My\ Community My-Community Community1 } # TESTING Valid community names for testing.
    valid_names.each do |name|
      Factory.build(:community, :name => name).should be_valid
    end
  end

  it "should reject invalid name" do
    invalid_names = %w{ 1212312&^*&^ #1Community My\ #1\ Community @TopComm } # TESTING Invalid community names for testing.
    invalid_names.each do |name|
      Factory.build(:community, :name => name).should_not be_valid
    end
  end

  it "should reject excluded name" do
    excluded_names = %w{ www wwW wWw wWW Www WwW WWw WWW }
    excluded_names.each do |name|
      Factory.build(:community, :name => name).should_not be_valid
    end
  end

  it "should accept valid label" do
    valid_labels = %w{ Guild Team Clan Faction Squad }
    valid_labels.each do |label|
      Factory.build(:community, :label => label).should be_valid
    end
  end

  it "should reject invalid label" do
    invlaid_labels = %w{ 1212312&^*&^ #1Community My\ #1\ Community @TopComm }  # TESTING Invalid community labels for testing.
    invlaid_labels.each do |label|
      Factory.build(:community, :label => label).should_not be_valid
    end
  end

  it "should create valid subdomain" do
    good_name_subdomain_hash = Hash[ "ALLUPPERCASENAME", "alluppercasename", "with space", "withspace", "with-dash", "withdash", "withnumber1", 'withnumber1'] # TESTING Valid community subdomain hash

    good_name_subdomain_hash.each do |name, subdomain|
      c = Factory.create(:community, :name => name)
      c.subdomain.should == subdomain
    end
  end

  it "should check subdomain uniqueness" do
    good_name_pairs_hash = Hash[ "OMGLOLOLOLOL", "MyCommunity", "My-Community", "Community1"] # TESTING Valid community pairs
    bad_name_pairs_hash = Hash[ "OMGLOLOLOLOL", "omglolololol", "My-Community", "My Community"] # TESTING Invalid community pairs

    good_name_pairs_hash.each  do |firstName, secondName|
      c = Factory.create(:community, :name => firstName)
      c.should be_valid
      Factory.build(:community, :name => secondName).should be_valid
      c.delete.should be_valid
    end

    bad_name_pairs_hash.each  do |firstName, secondName|
      c = Factory.create(:community, :name => firstName)
      c.should be_valid
      Factory.build(:community, :name => secondName).should_not be_valid
      c.delete.should be_valid
    end
  end

  it "should not allow name edit" do
    old_name = community.name
    community.update_attributes(:name => "ChangedName")
    community.name.should == old_name
  end

end

