# == Schema Information
#
# Table name: roles
#
#  id                  :integer          not null, primary key
#  community_id        :integer
#  name                :string(255)
#  is_system_generated :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  deleted_at          :datetime
#

require 'spec_helper'

describe Role do
  let(:role) { create(:role) }

  it "should create a new instance given valid attributes" do
    role.should be_valid
  end

  describe "community" do
    it "should be required" do
      build(:role, :community => nil).should_not be_valid
    end
  end

  describe "name" do
    it "should be unique within communities" do
      build(:role, :name => role.name, :community => role.community).should_not be_valid
    end
  end

  describe "destroy" do
    it "should mark role as deleted" do
      role.destroy
      Role.exists?(role).should be_false
      Role.with_deleted.exists?(role).should be_true
    end

    it "should mark role's permissions as deleted" do
      permission = create(:permission)
      role = permission.role
      role.destroy
      Permission.exists?(permission).should be_false
      Permission.with_deleted.exists?(permission).should be_true
    end

    it "should mark role's permission_defaults as deleted" do
      permission_default = role.permission_defaults.first
      permission_default.should be_a(PermissionDefault)

      role.destroy
      PermissionDefault.exists?(permission_default).should be_false
      PermissionDefault.with_deleted.exists?(permission_default).should be_true
    end
  end
end
