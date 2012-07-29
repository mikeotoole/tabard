# == Schema Information
#
# Table name: activities
#
#  id              :integer          not null, primary key
#  user_profile_id :integer
#  community_id    :integer
#  target_type     :string(255)
#  target_id       :integer
#  action          :string(255)
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Activity do
  let(:activity) { build(:activity) }
  
  it "should create a new instance given valid attributes" do
    activity.should be_valid
  end
  
  it "should require user_profile" do
    build(:activity, :user_profile => nil).should_not be_valid
  end
  
  it "should require target" do
    build(:activity, :target => nil).should_not be_valid
  end
  
  it "should require action" do
    build(:activity, :action => nil).should_not be_valid
  end
  
  describe "scope ordered" do
    it "should order activities by updated_at in descending order" do
      create_list(:activity, 10)
      
      list = Activity.ordered
      
      for i in 0..list.length
        (list[i].updated_at >= list[i+1].updated_at).should be_true if i+1 < list.length
      end
    end
  end
  
  it "should respond to community_name" do
    activity.should respond_to(:community_name)
  end
  
  it "should respond to community_name" do
    activity.should respond_to(:community_subdomain)
  end
  
  describe "activities" do
    before(:each) {
      for i in 1..5
        Timecop.return
        create(:activity, :user_profile => DefaultObjects.community_admin.user_profile)
        create(:comment, :user_profile => DefaultObjects.community_two.admin_profile, :community => DefaultObjects.community_two)
        Timecop.freeze(1.day.ago)
        create(:activity, :user_profile => DefaultObjects.community_two.admin_profile, :community => DefaultObjects.community_two)
        Timecop.freeze(2.day.ago)
        create(:comment, :user_profile => DefaultObjects.community_admin.user_profile)
      end
    }
  
    it "should return activities in descending order by updated_at" do
      list = Activity.activities({:user_profile_id => DefaultObjects.community_admin.user_profile_id})
      
      for i in 0..list.length
        (list[i].updated_at >= list[i+1].updated_at).should be_true if i+1 < list.length
      end
    end
    
    it "should return ten items by default" do
      Activity.all.count.should be > 10
      Activity.activities.count.should eql 10
    end
    
    it "when user_profile_id is specified should only return that users activities" do
      list = Activity.activities({:user_profile_id => DefaultObjects.community_admin.user_profile_id})
      
      list.each do |activity|
        activity.user_profile.should eql DefaultObjects.community_admin.user_profile
      end
    end
    
    it "when community_id is specified should only return that communities activities" do
      list = Activity.activities({:community_id => DefaultObjects.community_two.id})
      
      list.each do |activity|
        activity.community.should eql DefaultObjects.community_two
      end
    end
    
    it "when both user_profile_id and community_id is specified should only return activities for that user and community" do
      list = Activity.activities({:community_id => DefaultObjects.community_two.id, :user_profile_id => DefaultObjects.community_two.admin_profile.id})
      
      list.each do |activity|
        activity.community.should eql DefaultObjects.community_two
        activity.user_profile.should eql DefaultObjects.community_two.admin_profile
      end
    end
    
    it "when only since is given only activities that occurred after that date should be returned" do
      list = Activity.activities(nil, {:since => Time.now.to_s})
      
      list.each do |activity|
        activity.updated_at.should > Time.now
      end
    end
    
    it "when only before is given only activities that occurred before that date should be returned" do
      list = Activity.activities(nil, {:before => Time.now.to_s})
      
      list.each do |activity|
        activity.updated_at.should < Time.now
      end
    end
    
    it "when both since and before is given only activities that occurred between those dates should be returned" do
      list = Activity.activities(nil, {:since => 1.day.ago.to_s, :before => 2.day.ago.to_s})
      
      list.each do |activity|
        activity.updated_at.should < 1.day.ago
        activity.updated_at.should > 2.day.ago
      end
    end
    
    it "when max items is given a maximum of that number of items should be given" do
      Activity.activities(nil, nil, 5).count.should eql 5
    end
  end
end
