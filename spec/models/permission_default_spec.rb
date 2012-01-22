# == Schema Information
#
# Table name: permission_defaults
#
#  id                      :integer         not null, primary key
#  role_id                 :integer
#  object_class            :string(255)
#  permission_level        :string(255)
#  can_read                :boolean         default(FALSE)
#  can_update              :boolean         default(FALSE)
#  can_create              :boolean         default(FALSE)
#  can_destroy             :boolean         default(FALSE)
#  can_lock                :boolean         default(FALSE)
#  can_accept              :boolean         default(FALSE)
#  nested_permission_level :string(255)
#  can_read_nested         :boolean         default(FALSE)
#  can_update_nested       :boolean         default(FALSE)
#  can_create_nested       :boolean         default(FALSE)
#  can_destroy_nested      :boolean         default(FALSE)
#  can_lock_nested         :boolean         default(FALSE)
#  can_accept_nested       :boolean         default(FALSE)
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#

require 'spec_helper'

describe PermissionDefault do
  let(:some_new_role) { Factory.create(:role) }
  
  describe "should be autocreated for a role" do
    describe "for custom form" do
      let(:custom_form_defaults) { some_new_role.permission_defaults.find_by_object_class("CustomForm") }
      it "should exist" do
        custom_form_defaults.should_not be_nil
      end
      it "should have permission_level set to view" do
        custom_form_defaults.permission_level.should eq("View")
      end
      it "should not have any booleans set or nested set" do
        custom_form_defaults.can_lock.should be_false
        custom_form_defaults.can_accept.should be_false
        custom_form_defaults.can_read.should be_false
        custom_form_defaults.can_create.should be_false
        custom_form_defaults.can_update.should be_false
        custom_form_defaults.can_destroy.should be_false
        custom_form_defaults.can_lock_nested.should be_false
        custom_form_defaults.can_accept_nested.should be_false
        custom_form_defaults.can_read_nested.should be_false
        custom_form_defaults.can_create_nested.should be_false
        custom_form_defaults.can_update_nested.should be_false
        custom_form_defaults.can_destroy_nested.should be_false
        custom_form_defaults.nested_permission_level.should be_nil
      end
    end
    describe "for discussion space" do
      let(:discussion_space_defaults) { some_new_role.permission_defaults.find_by_object_class("DiscussionSpace") }
      it "should exist" do
        discussion_space_defaults.should_not be_nil
      end
      it "should have permission_level set to view" do
        discussion_space_defaults.permission_level.should eq("View")
      end
      it "should not have any booleans set or nested set" do
        discussion_space_defaults.can_lock.should be_false
        discussion_space_defaults.can_accept.should be_false
        discussion_space_defaults.can_read.should be_false
        discussion_space_defaults.can_create.should be_false
        discussion_space_defaults.can_update.should be_false
        discussion_space_defaults.can_destroy.should be_false
        discussion_space_defaults.can_lock_nested.should be_false
        discussion_space_defaults.can_accept_nested.should be_false
        discussion_space_defaults.can_read_nested.should be_false
        discussion_space_defaults.can_create_nested.should be_true
        discussion_space_defaults.can_update_nested.should be_false
        discussion_space_defaults.can_destroy_nested.should be_false
        discussion_space_defaults.nested_permission_level.should be_nil
      end
    end
    describe "for page space" do
      let(:page_space_defaults) { some_new_role.permission_defaults.find_by_object_class("PageSpace") }
      it "should exist" do
        page_space_defaults.should_not be_nil
      end
      it "should have permission_level set to view" do
        page_space_defaults.permission_level.should eq("View")
      end
      it "should only have create nested boolean set" do
        page_space_defaults.can_lock.should be_false
        page_space_defaults.can_accept.should be_false
        page_space_defaults.can_read.should be_false
        page_space_defaults.can_create.should be_false
        page_space_defaults.can_update.should be_false
        page_space_defaults.can_destroy.should be_false
        page_space_defaults.can_lock_nested.should be_false
        page_space_defaults.can_accept_nested.should be_false
        page_space_defaults.can_read_nested.should be_false
        page_space_defaults.can_create_nested.should be_false
        page_space_defaults.can_update_nested.should be_false
        page_space_defaults.can_destroy_nested.should be_false
        page_space_defaults.nested_permission_level.should be_nil
      end
    end
  end
  
  describe "destroy" do
    let(:custom_form_defaults) { some_new_role.permission_defaults.find_by_object_class("CustomForm") }
    
    it "should mark permission_default as deleted" do
      custom_form_defaults.destroy
      PermissionDefault.exists?(custom_form_defaults).should be_false
      PermissionDefault.with_deleted.exists?(custom_form_defaults).should be_true
    end
  end
end
