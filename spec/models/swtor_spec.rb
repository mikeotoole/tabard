# == Schema Information
#
# Table name: swtors
#
#  id          :integer          not null, primary key
#  faction     :string(255)
#  server_name :string(255)
#  server_type :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Swtor do
  let(:swtor) { create(:swtor) }

  it "should create a new instance given valid attributes" do
    swtor.should be_valid
  end
  
  describe "faction" do
    it "should be required" do
      build(:swtor, :faction => nil).should_not be_valid
    end
    
    it "should validate faction exists" do
      build(:swtor, :faction => "Not a faction").should_not be_valid
    end
  end
  
  describe "server_name" do
    it "should be required" do
      build(:swtor, :server_name => nil).should_not be_valid
    end
  end
  
  describe "server_type" do
    it "should be required" do
      build(:swtor, :server_type => nil).should_not be_valid
    end
    
    it "should validate server_type exists" do
      build(:swtor, :server_type => "Not a server type").should_not be_valid
    end
  end
end
