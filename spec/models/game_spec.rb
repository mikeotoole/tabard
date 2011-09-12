# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Game do
  let(:swtor) { Factory.create(:swtor) }

  describe "name" do
    it "should be required" do
      build(:swtor, :name => nil).should_not be_valid
    end
  end
    
  describe "type" do
    it "should be set to subclass name" do
      swtor == "Swtor"
    end
    
    it "shouldn't be editable to nil" do
      build(:swtor, :type => nil).should_not be_valid
    end
    
    it "should be editable to valid subclass" do
      valid_subclasses = %w{ Swtor Wow } # TESTING valid game types.
      valid_subclasses.each do |type|
        build(:swtor, :type => type).should be_valid
      end
    end
    
    it "shouldn't be editable to invalid subclass" do
      valid_subclasses = %w{ NotASubclass } # TESTING Invalid game types.
      valid_subclasses.each do |type|
        build(:swtor, :type => type).should_not be_valid
      end
    end
    
    it "should validate only one game of each type exists" do
      swtor.should be_valid
      build(:swtor, :type => "Swtor").should_not be_valid
    end
  end
end
