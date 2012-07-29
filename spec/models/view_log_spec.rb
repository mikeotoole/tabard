# == Schema Information
#
# Table name: view_logs
#
#  id                 :integer          not null, primary key
#  user_profile_id    :integer
#  view_loggable_id   :integer
#  view_loggable_type :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  deleted_at         :datetime
#

require 'spec_helper'

describe ViewLog do
  let(:discussion) { create(:discussion) }
  let(:user_profile) { DefaultObjects.user_profile }

  it "should create a new instance given valid attributes" do
    ViewLog.create(:user_profile => user_profile, :view_loggable => discussion).should be_valid
  end

  it "should require user_profile" do
    ViewLog.create(:user_profile => nil, :view_loggable => discussion).should_not be_valid
  end

  it "should require view_loggable" do
    ViewLog.create(:user_profile => user_profile, :view_loggable => nil).should_not be_valid
  end
end
