# == Schema Information
#
# Table name: minecrafts
#
#  id          :integer          not null, primary key
#  server_type :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Minecraft do
  let(:minecraft) { create(:minecraft) }

  it "should create a new instance given valid attributes" do
    minecraft.should be_valid
  end
  
  describe "server_type" do
    it "should be required" do
      build(:minecraft, :server_type => nil).should_not be_valid
    end
    
    it "should validate server_type exists" do
      build(:minecraft, :server_type => "Not a server type").should_not be_valid
    end
  end
end
