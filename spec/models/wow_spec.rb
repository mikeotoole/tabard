# == Schema Information
#
# Table name: wows
#
#  id          :integer          not null, primary key
#  faction     :string(255)
#  server_name :string(255)
#  server_type :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Wow do
  let(:wow) { create(:wow) }

  it "should create a new instance given valid attributes" do
    wow.should be_valid
  end
  
  describe "faction" do
    it "should be required" do
      build(:wow, :faction => nil).should_not be_valid
    end
    
    it "should validate faction exists" do
      build(:wow, :faction => "Not a faction").should_not be_valid
    end
  end
  
  describe "server_name" do
    it "should be required" do
      build(:wow, :server_name => nil).should_not be_valid
    end
  end
  
  describe "server_type" do
    it "should be required" do
      build(:wow, :server_type => nil).should_not be_valid
    end
    
    it "should validate server_type exists" do
      build(:wow, :server_type => "Not a server type").should_not be_valid
    end
  end
end
