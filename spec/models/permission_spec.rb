# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  is_active  :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
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
  
  describe "subject class" do
    it "should have a limited inclusion set" do
      valid_classes = %w{ Role } # TESTING Valid subject classes for testing.
      valid_classes.each do |valid_class|
        build(:permission, :subject_class => valid_class).should be_valid
      end
    end
  end
  
  describe "permission_level" do
    it "should have a limited inclusion set" do
      invalid_classes = %w{ Admin User UserProfile Community } # TESTING Invalid subject classes for testing.
      invalid_classes.each do |invalid_class|
        build(:permission, :subject_class => invalid_class).should_not be_valid
      end
    end
  end
  
  it "should be valid with an action and no permission" do
    build(:permission, :action => "manage", :permission_level => "").should be_valid
  end
  
  it "should be valid with a permission and no action" do
    build(:permission, :action => "", :permission_level => "View").should be_valid
  end
  
  it "should not be valid with no permission and no action" do
    build(:permission, :action => "", :permission_level => "").should_not be_valid
  end
  
  it "should not be valid with a permission and an action" do
    build(:permission, :action => "manage", :permission_level => "View").should_not be_valid
  end
end