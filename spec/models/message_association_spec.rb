# == Schema Information
#
# Table name: message_associations
#
#  id            :integer         not null, primary key
#  message_id    :integer
#  recipient_id  :integer
#  folder_id     :integer
#  deleted       :boolean         default(FALSE)
#  has_been_read :boolean         default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe MessageAssociation do
  let(:message_association) { create(:message).message_associations.first }

  it "should create a new instance given valid attributes" do
    message_association.should be_valid
  end

  it "should require message" do
    message_association.should be_valid
    message_association.message = nil
    message_association.save.should be_false
  end

  it "should require recipient" do
    message_association.should be_valid
    message_association.recipient = nil
    message_association.save.should be_false
  end
  
  it "should set has_been_read to false by default" do
    message_association.has_been_read.should be_false
  end
  
  it "should not allow mass assignment of message" do
    new_message = create(:message)
    new_message.should be_valid
    old_message = message_association.message
    message_association.update_attributes(:message => new_message)
    MessageAssociation.find(message_association).message.should eq(old_message)
  end
  
  it "should allow mass assignment of deleted" do
    message_association.deleted.should be_false
    message_association.update_attributes(:deleted => true)
    MessageAssociation.find(message_association).deleted.should be_true
  end
  
  it "should allow mass assignment of recipient_id" do
    new_recipient_id = create(:user_profile).id
    message_association.update_attributes(:recipient_id => new_recipient_id)
    MessageAssociation.find(message_association).recipient_id.should eq(new_recipient_id)
  end

  it "should allow mass assignment of folder_id" do
    new_folder_id = create(:folder).id
    message_association.update_attributes(:folder_id => new_folder_id)
    MessageAssociation.find(message_association).folder_id.should eq(new_folder_id)
  end
  
  it "should respond to author" do
    message_association.should respond_to(:author)
  end
  
  it "should respond to created_at" do
    message_association.should respond_to(:created_at)
  end
  
  it "should respond to subject" do
    message_association.should respond_to(:subject)
  end
  
  it "should respond to body" do
    message_association.should respond_to(:body)
  end
  
  it "should respond to recipients" do
    message_association.should respond_to(:recipients)
  end
  
  it "should respond to recipients" do
    message_association.should respond_to(:has_been_read)
  end
end
