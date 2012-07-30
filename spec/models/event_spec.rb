# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  body              :text
#  start_time        :datetime
#  end_time          :datetime
#  creator_id        :integer
#  supported_game_id :integer
#  community_id      :integer
#  is_public         :boolean          default(FALSE)
#  location          :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe Event do
  let(:event) { create(:event) }

  it "should create a new instance given valid attributes" do
    event.should be_valid
  end

  it "should require name" do
    build(:event, :name => nil).should_not be_valid
  end

  it "should require body" do
    build(:event, :body => nil).should_not be_valid
  end

  it "should require start_time" do
    build(:event, :start_time => nil).should_not be_valid
  end

  it "should require end_time" do
    build(:event, :end_time => nil).should_not be_valid
  end

  it "should require start_time is before end_time" do
    build(:event, :end_time => 1.days.ago.to_date).should_not be_valid
  end

  it "should require creator" do
    event.should be_valid
    event.creator = nil
    event.save.should be_false
  end

  it "should require community" do
    event.should be_valid
    event.community = nil
    event.save.should be_false
  end

  it "should set is_public to false by default" do
    event.should be_valid
    event.is_public.should be_false
  end

  it "should not allow access to creator_id" do
    event.should be_valid
    old_creator_id = event.creator_id
    event.update_attributes(:creator_id => old_creator_id + 10)
    new_event = Event.find(event)
    new_event.creator_id.should eq(old_creator_id)
  end

  it "should not allow access to community_id" do
    event.should be_valid
    old_community_id = event.community_id
    event.update_attributes(:community_id => old_community_id + 10)
    new_event = Event.find(event)
    new_event.community_id.should eq(old_community_id)
  end

#   it "should respond to participants" do
#     event.should respond_to(:participants)
#   end
#
#   it "should respond to invites" do
#     event.should respond_to(:invites)
#   end
#
#   describe "attendees" do
#     it "should return all attendees of event" do
#       event.should respond_to(:attendees)
#       participant = create(:participant)
#       event.attendees.count.should eq(1)
#       event.attendees.first.should eq(participant.user_profile)
#     end
#
#     it "should return character and not user profile when character is present" do
#       event.should respond_to(:attendees)
#       participant = create(:participant_as_wow_char)
#       event.attendees.count.should eq(1)
#       event.attendees.first.should eq(participant.character_proxy.character)
#     end
#   end
#
#   describe "invitees" do
#     it "should return all invitees of event" do
#       event.should respond_to(:invitees)
#       invite = create(:invite)
#       event.invitees.count.should eq(1)
#       event.invitees.first.should eq(invite.user_profile)
#     end
#
#     it "should return character and not user profile when character is present" do
#       event.should respond_to(:invitees)
#       invite = create(:invite_to_wow_char)
#       event.invitees.count.should eq(1)
#       event.invitees.first.should eq(invite.character_proxy.character)
#     end
#   end

end
