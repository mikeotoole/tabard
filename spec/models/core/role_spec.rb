# == Schema Information
#
# Table name: roles
#
#  id               :integer         not null, primary key
#  community_id     :integer
#  name             :string(255)
#  system_generated :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Role do
  let(:role) { Factory.create(:role) }
  
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
end
