# == Schema Information
#
# Table name: folders
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  user_profile_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Folder do
  let(:folder) { create(:folder) }

  it "should create a new instance given valid attributes" do
    folder.should be_valid
  end

  it "should require name" do
    build(:folder, :name => nil).should_not be_valid
  end

  it "should require user profile" do
    folder.should be_valid
    folder.user_profile = nil
    folder.save.should be_false
  end
  
  it "should respond to messages" do
    folder.should respond_to(:messages)
  end
end
