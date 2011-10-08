# == Schema Information
#
# Table name: answers
#
#  id            :integer         not null, primary key
#  body          :text
#  question_id   :integer
#  submission_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'
require "cancan/matchers"

describe Ability do
  ###
  # Here is a quick example to writing tests for cancan using the magical cancan matcher:
  #
  # Create some user => user = User.create!
  #   * This would most likely be the factory of your choice.
  #
  # Next you create cancan ability.
  # ability = Ability.new(user)
  #
  # Then you can test what they can and can't do:
  # ability.should be_able_to(:destroy, Project.new(:user => user))
  # ability.should_not be_able_to(:destroy, Project.new)
  #
  ###
  describe "baked in rules" do
    describe "An anonymous user" do
      let(:ability) { Ability.new(User.new) }
      pending
    end
    describe "A basic member" do
      #
      pending
    end
  end
  describe "dynamic rules" do
    before(:each) do
      @community_profile_with_characters = create(:community_profile_with_characters)
      @community = @community_profile_with_characters.community
      @user_profile = @community_profile_with_characters.user_profile
    end
    describe "should be community specific" do
      before(:each) do
        @different_community = create(:community)
        app = @different_community.community_applications.new(:character_proxies => @user_profile.character_proxies)
        app.prep(@user_profile, @different_community.community_application_form)
        app.save
        app.accept_application
        @specific_role = @community.roles.create(:name => "Uber N00b!", :community => @community)
        @specific_role.permissions.create(:subject_class => "Role", :permission_level => "Delete", :role => @specific_role)
        @user_profile.add_new_role(@specific_role)
        @user_profile = UserProfile.find(@user_profile)
      end
      it "should work in the context of a community" do
        ability = Ability.new(@user_profile.user)
        ability.dynamicContextRules(@user_profile.user, @community)
        ability.should be_able_to(:read, @community.roles.new)
        ability.should be_able_to(:update, @community.roles.new)
        ability.should be_able_to(:create, @community.roles.new)
        ability.should be_able_to(:destroy, @community.roles.new)
      end
      it "should not work in context of a different community" do
        ability = Ability.new(@user_profile.user)
        ability.dynamicContextRules(@user_profile.user, @different_community)
        ability.should_not be_able_to(:read, @different_community.roles.new)
        ability.should_not be_able_to(:update, @different_community.roles.new)
        ability.should_not be_able_to(:create, @different_community.roles.new)
        ability.should_not be_able_to(:destroy, @different_community.roles.new)
      end
    end
  end
end
