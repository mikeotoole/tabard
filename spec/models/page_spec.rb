# == Schema Information
#
# Table name: pages
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  markup             :text
#  character_proxy_id :integer
#  user_profile_id    :integer
#  page_space_id      :integer
#  show_in_navigation :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Page do
  let(:page) { create(:page) }
  let(:wow_page) { create(:page_by_wow_character) }
  let(:user_profile) { DefaultObjects.user_profile }

  it "should create a new instance given valid attributes" do
    page.should be_valid
  end

  it "should require name" do
    build(:page, :name => nil).should_not be_valid
  end

  it "should require markup" do
    build(:page, :markup => nil).should_not be_valid
  end

  it "should require user profile" do
    page.should be_valid
    page.user_profile = nil
    page.save.should be_false
  end
  
  it "should require page space" do
    page.should be_valid
    page.page_space = nil
    page.save.should be_false
  end
  
  it "should respond to community" do
    page.should respond_to(:community)
  end
  
  it "should respond to show_in_navigation" do
    page.should respond_to(:show_in_navigation)
  end
  
  it "should respond to body" do
    page.should respond_to(:body)
  end
  
  describe "body" do
    it "should return markup converted to html" do
      page.body.include?('<h2>H2 Heading</h2>').should be_true
      page.body.include?('<em>Bold</em>').should be_true
    end
  end
  
  it "poster should return the user profile when there is no character proxy" do
    page.poster.should eq(DefaultObjects.user_profile)
  end 
  
  it "poster should return the character when there is a character proxy" do
    wow_page.poster.should be_a_kind_of(WowCharacter)
  end
  
  it "charater_posted? should return false when there is no character proxy" do
    page.charater_posted?.should be_false
  end 
  
  it "charater_posted? should return true when there is a character proxy" do
    wow_page.charater_posted?.should be_true
  end 
  
  it "should set show_in_navigation to false by default" do
    page.show_in_navigation.should be_false
  end
  
  it "should allow show_in_navigation to be set" do
    create(:page, :show_in_navigation => true).show_in_navigation.should be_true
  end

  it "should only allow 5 pages to be shown in navigation" do
    create_list(:page, 5, :show_in_navigation => true)
    build(:page, :show_in_navigation => true).should_not be_valid
  end  
  
end
