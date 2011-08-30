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
    ok_names = %w{ OMGLOLOLOLOL } # TESTING Valid community names for testing.
    bad_names = %w{ 1212312&^*&^ } # TESTING Invalid community names for testing.
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
    invlaid_labels = %w{ Herp Derp Zerp }
    # TODO Write this method.
  end
###
# Test Methods
###
  def new_community(name)
    Community.new(:name => name,
      :slogan => "We rock!",
      :label => "Guild")
  end
end
