# == Schema Information
#
# Table name: messages
#
#  id                :integer         not null, primary key
#  subject           :string(255)
#  body              :text
#  author_id         :integer
#  number_recipients :integer
#  system_sent       :boolean         default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Message do
  let(:message) { create(:message) }

  it "should create a new instance given valid attributes" do
    message.should be_valid
  end

  it "should require subject" do
    build(:message, :subject => nil).should_not be_valid
  end

  it "should require body" do
    build(:message, :body => nil).should_not be_valid
  end
  
  it "should require to" do
    build(:message, :to => nil).should_not be_valid
  end
  
  it "should set system_sent to false by default" do
    message.system_sent.should be_false
  end
  
  it "should respond to message_associations" do
    message.should respond_to(:message_associations)
  end
  
  it "should respond to recipients" do
    message.should respond_to(:recipients)
  end
  
  it "should respond to number_recipients" do
    message.should respond_to(:number_recipients)
  end
  
  it "should not allow mass assignment of number_recipients" do
    message.number_recipients.should eq(1)
    message.update_attributes(:number_recipients => 10)
    Message.find(message).number_recipients.should eq(1)
  end
  
  it "should not allow mass assignment of author" do
    org_author = message.author
    new_author = create(:user_profile)
    new_author.should be_valid
    message.update_attributes(:author => new_author)
    Message.find(message).author.should eq(org_author)
  end
  
  it "should not allow mass assignment of system_sent" do
    message.system_sent.should be_false
    message.update_attributes(:system_sent => true)
    Message.find(message).system_sent.should be_false
  end
  
  it "should create a message_association for all users the message is to" do
    build(:message).to.count.should eq(1)
    message.message_associations.count.should eq(1)
  end
  
  it "should set number_recipients to the number of users the message is to" do
    build(:message).to.count.should eq(1)
    message.number_recipients.should eq(1)
  end
  
  it "should put message_association in the users inbox" do
    message.message_associations.first.folder.name.should eq("Inbox")
  end
  
  describe "recipients" do
    it "should return all recipients" do
      message.recipients.count.should eq(1)
    end
  end
  
  it "should destroy all message associations when message is deleted" do
    message
    MessageAssociation.all.count.should eq(1)
    Message.all.count.should eq(1)
    message.destroy
    MessageAssociation.all.count.should eq(0)
    Message.all.count.should eq(0)
  end
end
