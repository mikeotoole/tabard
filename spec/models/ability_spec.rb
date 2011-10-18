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
  describe "for an anonymous user" do
    before(:each) do
      @anonymous = User.new
      @ability = Ability.new(@anonymous)
    end
    describe "can visit main page + crumblin information pages" do
      pending
    end
    it "can create an account" do
      @ability.should be_able_to(:create, User.new)
    end
    it "can log in" do
      pending
    end
    #In the scope of a community they are treated as a non member, with the exception that they can not apply to a community.
  end
  describe "for a crumblin member" do
    pending
  end
  describe "for dynamic rules" do
    before(:each) do
      @community_profile_with_characters = create(:community_profile_with_characters)
      @community = @community_profile_with_characters.community
      @user_profile = @community_profile_with_characters.user_profile
      @community_member_user = @user_profile.user
      @community_admin_user = @community.admin_profile.user
      @different_community = create(:community)
    end
    describe "should be community specific" do
      before(:each) do
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

    describe "for a community member" do
      pending
    end

    describe "for a community admin" do
      pending
    end
    describe "for role testing" do
      def create_new_permission(subject, permission_level, subject_id = nil, parent = nil, parent_id = nil)
        if subject_id
          @community_profile_with_characters.roles.first.permissions.create(:subject_class => subject,
            :permission_level => permission_level,
            :id_of_subject => subject_id
          )
        else
          @community_profile_with_characters.roles.first.permissions.create(:subject_class => subject,
            :permission_level => permission_level
          ) 
        end
      end

      def test_all_basic_role_permission_levels(test_object)
        describe "#{test_object} basic action test"
        test_simple_role_test(test_object, "View")
        test_simple_role_test(test_object, "Update")
        test_simple_role_test(test_object, "Create")
        test_simple_role_test(test_object, "Delete")
      end

      def test_simple_role_test(test_object, permission_level)
        describe "#{permission_level} level"  do
          before(:each) do
            if test_object.id?
              create_new_permission(test_object.class.to_s, permission_level, test_object.id)
            else
              create_new_permission(test_object.class.to_s, permission_level)
            end
          end
          it "should allow read if view level is set in the same community" do
            test_ability(permission_level, test_object)
          end
          it "should not allow read if view level is set in the different community" do
            test_no_ability(permission_level, test_object)
          end
        end
      end

      def test_ability(permission_level, item)
        ability = Ability.new(@user_profile.user)
        ability.dynamicContextRules(@user_profile.user, @community)
        case permission_level
          when "Delete"
            ability.should be_able_to(:read, item)
            ability.should be_able_to(:update, item)
            ability.should be_able_to(:create, item)
            ability.should be_able_to(:destroy, item)
          when "Create"
            ability.should be_able_to(:read, item)
            ability.should be_able_to(:update, item)
            ability.should be_able_to(:create, item)
            ability.should_not be_able_to(:destroy, item)
          when "Update"
            ability.should be_able_to(:read, item)
            ability.should be_able_to(:update, item)
            ability.should_not be_able_to(:create, item)
            ability.should_not be_able_to(:destroy, item)
          when "View"
            ability.should be_able_to(:read, item)
            ability.should_not be_able_to(:update, item)
            ability.should_not be_able_to(:create, item)
            ability.should_not be_able_to(:destroy, item)
        end
      end
      def test_no_ability(permission_level, item)
        ability = Ability.new(@user_profile.user)
        ability.dynamicContextRules(@user_profile.user, @different_community)
        ability.should_not be_able_to(:read, item)
        ability.should_not be_able_to(:update, item)
        ability.should_not be_able_to(:create, item)
        ability.should_not be_able_to(:destroy, item)
      end
      describe "comment" do
        some_new_comment = Comment.new
        test_all_basic_role_permission_levels(some_new_comment)
      end
      describe "page spaces" do
        describe "view level"  do
          it "should allow read if view level is set in the same community" do
            create_new_permission("PageSpace", "View")
            test_ability("View", @community.page_spaces.new)
          end
          it "should not allow read if view level is set in the different community" do
            create_new_permission("PageSpace", "View")
            test_no_ability("View", @different_community.page_spaces.new)
          end
          describe "Specific Space" do
            before(:each) do
              @page_space = @community.page_spaces.create(:name => "Some space")
              @some_other_page_space = @community.page_spaces.create(:name => "Some other space")
              create_new_permission("PageSpace", "View", @page_space.id)
            end
            it "should allow for specified space" do
              test_ability("View", @page_space)
            end
            it "should not allow for something other than specified space" do
              test_no_ability("View", @page_space)
            end
          end
        end
        describe "Update level"  do
          it "should allow in the same community" do
            create_new_permission("PageSpace", "Update")
            test_ability("Update", @community.page_spaces.new)
          end
          it "should not allow different community" do
            create_new_permission("PageSpace", "Update")
            test_no_ability("Update", @different_community.page_spaces.new)
          end
          describe "Specific Space" do
            before(:each) do
              @page_space = @community.page_spaces.create(:name => "Some space")
              @some_other_page_space = @community.page_spaces.create(:name => "Some other space")
              create_new_permission("PageSpace", "Update", @page_space.id)
            end
            it "should allow for specified space" do
              test_ability("Update", @page_space)
            end
            it "should not allow for something other than specified space" do
              test_no_ability("Update", @some_other_page_space)
            end
          end
        end
        describe "Create level"  do
          it "should allow in the same community" do
            create_new_permission("PageSpace", "Create")
            test_ability("Create", @community.page_spaces.new)
          end
          it "should not allow different community" do
            create_new_permission("PageSpace", "Create")
            test_ability("Create", @different_community.page_spaces.new)
          end
          describe "Specific Space" do
            before(:each) do
              @page_space = @community.page_spaces.create(:name => "Some space")
              @some_other_page_space = @community.page_spaces.create(:name => "Some other space")
              create_new_permission("PageSpace", "Create", @page_space.id)
            end
            it "should allow for specified space" do
              test_ability("Create", @page_space)
            end
            it "should not allow for something other than specified space" do
              test_no_ability("Create", @some_other_page_space)
            end
          end
        end
        describe "Delete level"  do
          it "should allow in the same community" do
            create_new_permission("PageSpace", "Delete")
            test_ability("Delete", @community.page_spaces.new)
          end
          it "should not allow different community" do
            create_new_permission("PageSpace", "Delete")
            test_no_ability("Delete", @different_community.page_spaces.new)
          end
          describe "Specific Space" do
            before(:each) do
              @page_space = @community.page_spaces.create(:name => "Some space")
              @some_other_page_space = @community.page_spaces.create(:name => "Some other space")
              create_new_permission("PageSpace", "Delete", @page_space.id)
            end
            it "should allow for specified space" do
              test_ability("Delete", @page_space)
            end
            it "should not allow for something other than specified space" do
              test_no_ability("Delete", @some_other_page_space)
            end
          end
        end
      end
      describe "page" do
        before(:each) do
          @page_space = @community.page_spaces.create(:name => "Some space")
          @some_other_page_space = @community.page_spaces.create(:name => "Some other space")
          @another_community_page_space = @different_community.page_spaces.create(:name => "Some space")
        end
        describe "view level"  do
          it "should allow read if view level is set in the same community" do
            create_new_permission("Page", "View")
            test_ability("View", @page_space.pages.new)
          end
          it "should not allow read if view level is set in the different community" do
            create_new_permission("Page", "View")
            test_no_ability("View", @another_community_page_space.pages.new)
          end
          describe "Specific Page" do
            before(:each) do
              @page = @page_space.pages.new(:name => "Some space",
                :markup => "lololol")
              @page.user_profile = @user_profile
              @page.save
              @some_other_page_in_same_page_space = @page_space.pages.new(:name => "Some pther space",
                :markup => "lololol")
              @some_other_page_in_same_page_space.user_profile = @user_profile
              @some_other_page_in_same_page_space.save
              create_new_permission("Page", "View", @page.id)
            end
            it "should allow for specified page" do
              test_ability("View", @page)
            end
            it "should not allow for something other than specified page" do
              test_no_ability("View", @some_other_page_in_same_page_space)
            end
          end
        end
        describe "Update level"  do
          it "should allow in the same community" do
            create_new_permission("Page", "Update")
            test_ability("Update", @page_space.pages.new)
          end
          it "should not allow different community" do
            create_new_permission("Page", "Update")
            test_no_ability("Update", @another_community_page_space.pages.new)
          end
          describe "Specific Page" do
            before(:each) do
              @page = @page_space.pages.new(:name => "Some space",
                :markup => "lololol")
              @page.user_profile = @user_profile
              @page.save
              @some_other_page_in_same_page_space = @page_space.pages.new(:name => "Some pther space",
                :markup => "lololol")
              @some_other_page_in_same_page_space.user_profile = @user_profile
              @some_other_page_in_same_page_space.save
              create_new_permission("Page", "Update", @page.id)
            end
            it "should allow for specified page" do
              test_ability("Update", @page)
            end
            it "should not allow for something other than specified page" do
              test_no_ability("Update", @some_other_page_in_same_page_space)
            end
          end
        end
        describe "Create level"  do
          it "should allow in the same community" do
            create_new_permission("Page", "Create")
            test_ability("Create", @page_space.pages.new)
          end
          it "should not allow different community" do
            create_new_permission("Page", "Create")
            test_no_ability("Create", @another_community_page_space.pages.new)
          end
          describe "Specific Page" do
            before(:each) do
              @page = @page_space.pages.new(:name => "Some space",
                :markup => "lololol")
              @page.user_profile = @user_profile
              @page.save
              @some_other_page_in_same_page_space = @page_space.pages.new(:name => "Some pther space",
                :markup => "lololol")
              @some_other_page_in_same_page_space.user_profile = @user_profile
              @some_other_page_in_same_page_space.save
              create_new_permission("Page", "Create", @page.id)
            end
            it "should allow for specified page" do
              test_ability("Create", @page)
            end
            it "should not allow for something other than specified page" do
              test_no_ability("Create", @some_other_page_in_same_page_space)
            end
          end
        end
        describe "Delete level"  do
          it "should allow in the same community" do
            create_new_permission("Page", "Delete")
            test_ability("Delete", @page_space.pages.new)
          end
          it "should not allow different community" do
            create_new_permission("Page", "Delete")
            test_no_ability("Delete", @another_community_page_space.pages.new)
          end
          describe "Specific Page" do
            before(:each) do
              @page = @page_space.pages.new(:name => "Some space",
                :markup => "lololol")
              @page.user_profile = @user_profile
              @page.save
              @some_other_page_in_same_page_space = @page_space.pages.new(:name => "Some pther space",
                :markup => "lololol")
              @some_other_page_in_same_page_space.user_profile = @user_profile
              @some_other_page_in_same_page_space.save
              create_new_permission("Page", "Delete", @page.id)
            end
            it "should allow for specified page" do
              test_ability("Delete", @page)
            end
            it "should not allow for something other than specified page" do
              test_no_ability("Delete", @some_other_page_in_same_page_space)
            end
          end
        end
      end
    end
  end
end
