# == Schema Information
#
# Table name: themes
#
#  id                    :integer         not null, primary key
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  name                  :string(255)
#  css                   :string(255)
#  background_author     :string(255)
#  background_author_url :string(255)
#  thumbnail             :string(255)
#

require 'spec_helper'

describe Theme do
  let(:theme) { create(:theme) }

  it "should create a new instance given valid attributes" do
    theme.should be_valid
  end

  describe "name" do
    it "should be unique" do
      build(:theme, :name => theme.name).should_not be_valid
    end
    it "should be required" do
      build(:theme, :name => nil).should_not be_valid
    end
  end
  describe "css" do
    it "should be required" do
      build(:theme, :css => nil).should_not be_valid
    end
  end
  describe "background_author" do
    it "should be required if there is a background_author_url" do
      build(:theme, :background_author => nil, :background_author_url => "Herp").should_not be_valid
    end
    it "should not be required if there is no background_author_url" do
      build(:theme, :background_author => nil, :background_author_url => nil).should be_valid
    end
  end
  describe "background_author_url" do
    it "should not be required" do
      build(:theme, :background_author_url => nil, :background_author => nil).should be_valid
    end
  end
  describe "thumbnail" do
    it "should be required" do
      build(:theme, :thumbnail => nil).should_not be_valid
    end
  end
end
