# == Schema Information
#
# Table name: communities
#
#  id                          :integer         not null, primary key
#  name                        :string(255)
#  slogan                      :string(255)
#  label                       :string(255)
#  accepting_members           :boolean         default(TRUE)
#  email_notice_on_application :boolean         default(TRUE)
#  subdomain                   :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#

require 'test_helper'

class CommunityTest < ActiveSupport::TestCase

###
# Fixtures
###
  fixtures :communities

###
# Validator Tests
###

  test "community creation presence validation test" do
    community = Community.new
    assert community.invalid?, "should be an invalid community"
    assert community.errors[:name].any?, "should not allow blank name"
    assert community.errors[:slogan].any?, "should not allow blank slogan"
    assert community.errors[:label].any?, "should not allow blank label"
  end

  test "community creation default booleans test" do
    community = Community.new
    assert community.accepting_members, "should be accepting members by default"
    assert community.email_notice_on_application, "should email on application by default"
  end

  test "community creation name format and exclusion test" do
    ok_names = %w{ OMGLOLOLOLOL My\ Community My-Community Community1 } # TESTING Valid community names for testing.
    bad_names = %w{ 1212312&^*&^ #1Community My\ #1\ Community @TopComm } # TESTING Invalid community names for testing.
    excluded_names = %w{ www wwW wWw wWW Www WwW WWw WWW }

    ok_names.each do |name|
      assert new_community(name).valid?, "#{name} should be valid"
    end

    bad_names.each do |name|
      assert new_community(name).invalid?, "#{name} should not be valid"
    end

    excluded_names.each do |name|
      assert new_community(name).invalid?, "#{name} should not be valid"
    end
  end

  test "community creation label inclusion" do
    valid_labels = %w{ Guild Team Clan Faction Squad }
    invlaid_labels = %w{ Herp Derp Zerp Guil }

    valid_labels.each do |label|
      assert new_community_with_label(label).valid?, "#{label} should be valid"
    end

    invlaid_labels.each do |label|
      assert new_community_with_label(label).invalid?, "#{label} shouldn't' be valid"
    end
  end

  test "name convertion to subdomain" do
    good_name_subdomain_hash = Hash[ "OMGLOLOLOLOL", "omglolololol", "My Community", "mycommunity", "My-Community", "mycommunity", "Community1", 'community1'] # TESTING Valid community subdomain hash
    bad_name_subdomain_hash = Hash[ "OMGLOLOLOLOL", "OMGLOLOLOLOL", "My Community", "My Community", "My-Community", "My-Community", "Community1", 'Community1'] # TESTING Invalid community subdomain hash

    good_name_subdomain_hash.each do |key, value|
      c = new_community(key)
      assert c.save, "#{key} should be saved..."
      assert_equal value, c.subdomain, "#{value} should be a valid subdomain for #{key}"
      assert c.delete, "#{key} should be deleted..."
    end

    bad_name_subdomain_hash.each  do |key, value|
      c = new_community(key)
      assert c.save, "#{key} should be saved..."
      assert_not_equal value, c.subdomain, "#{value} shouldn't be a valid subdomain for #{key}"
      assert c.delete, "#{key} should be deleted..."
    end
  end

  test "community creation name uniqueness" do
    good_name_pairs_hash = Hash[ "OMGLOLOLOLOL", "MyCommunity", "My-Community", "Community1"] # TESTING Valid community pairs
    bad_name_pairs_hash = Hash[ "OMGLOLOLOLOL", "omglolololol", "My-Community", "My Community"] # TESTING Invalid community pairs

    good_name_pairs_hash.each  do |firstName, secondName|
      c = new_community(firstName)
      assert c.save, "#{firstName} should be saved..."
      assert new_community(secondName).valid?, "#{secondName} should be valid"
      assert c.delete, "#{firstName} should be deleted..."
    end

    bad_name_pairs_hash.each  do |firstName, secondName|
      c = new_community(firstName)
      assert c.save, "#{firstName} should be saved..."
      assert new_community(secondName).invalid?, "#{secondName} shouldn't be valid"
      assert c.delete, "#{firstName} should be deleted..."
    end
  end

  test "community name edit not allowed test" do
	community = communities(:one)
        old_name = community.name
  	assert !community.update_attributes(:name => "ChangedName"), "Update attribute name should fail."
        new_name = community.name
        assert_equal old_name, new_name, "name should not change."
  end

###
# Test Methods
###

  def new_community(name)
    Community.new(:name => name,
      :slogan => "We rock",
      :label => "Guild")
  end

  def new_community_with_label(label)
    Community.new(:name => "My Community",
      :slogan => "We rock!",
      :label => label)
  end
end
