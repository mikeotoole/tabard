# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  is_active  :boolean         default(TRUE)
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
  end
  
  describe "is_active" do
    it "should be set to true by default" do
      swtor.is_active.should be_true
    end
  end
  
  describe "active" do
    it "should only return active games" do
      create_list(:swtor, 3)
      create_list(:inactive_swtor, 2)
      Game.active.size.should eq(3)
    end
  end
  
  it "should return all subclass names with select_options" do
    valid_subclasses = %w{ Swtor Wow } # TESTING valid game types.
    valid_subclasses.each do |name|
      Game.select_options.include?(name).should be_true
    end
  end
  
  describe "type_helper" do
    it "should set type" do
      swtor.type_helper = "Wow"
      swtor.type.should eq("Wow")
    end
    
    it "should get type" do
      swtor.type_helper.should eq("Swtor")
    end
  end

end