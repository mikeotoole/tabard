# == Schema Information
#
# Table name: wows
#
#  id          :integer         not null, primary key
#  faction     :string(255)
#  server_name :string(255)
#  server_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Wow do
  let(:wow) { create(:wow) }

  it "should create a new instance given valid attributes" do
    wow.should be_valid
  end
  
  describe "faction" do
    it "should be required" do
      pending
    end
  end
  
  describe "server_name" do
    it "should be required" do
      pending
    end
  end
  
  describe "server_type" do
    it "should be required" do
      pending
    end
  end
end
