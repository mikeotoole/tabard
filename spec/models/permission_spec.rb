# == Schema Information
#
# Table name: permissions
#
#  id                             :integer         not null, primary key
#  role_id                        :integer
#  permission_level               :string(255)
#  subject_class                  :string(255)
#  id_of_subject                  :integer(255)
#  created_at                     :datetime
#  updated_at                     :datetime
#  can_lock                       :boolean         default(FALSE)
#  can_accept                     :boolean         default(FALSE)
#  parent_association_for_subject :string(255)
#  id_of_parent                   :integer
#  can_read                       :boolean         default(FALSE)
#  can_create                     :boolean         default(FALSE)
#  can_update                     :boolean         default(FALSE)
#  can_destroy                    :boolean         default(FALSE)
#  deleted_at                     :datetime
#

require 'spec_helper'

describe Permission do
  let(:permission) { Factory.create(:permission) }
  
  it "should create a new instance given valid attributes" do
    permission.should be_valid
  end

  describe "role" do
    it "should be required" do
      build(:permission, :role => nil).should_not be_valid
    end
  end
  
  describe "subject_class" do
    it "should have a limited inclusion set" do
      valid_classes = %w{ Comment CustomForm PageSpace Page DiscussionSpace Discussion CommunityApplication } # TESTING Valid subject classes for testing.
      valid_classes.each do |valid_class|
        build(:permission, :subject_class => valid_class).should be_valid
      end
      invalid_classes = %w{ Admin User UserProfile Community } # TESTING Invalid subject classes for testing.
      invalid_classes.each do |invalid_class|
        build(:permission, :subject_class => invalid_class).should_not be_valid
      end
    end
  end
  
  describe "permission_level" do
    it "should have a limited inclusion set" do
      valid_levels = %w{ View Update Create Delete } # TESTING Valid subject classes for testing.
      valid_levels.each do |valid_level|
        build(:permission, :permission_level => valid_level).should be_valid
      end
      invalid_levels = %w{ Make New } # TESTING Invalid subject classes for testing.
      invalid_levels.each do |invalid_level|
        build(:permission, :permission_level => invalid_level).should_not be_valid
      end
    end
  end
end
