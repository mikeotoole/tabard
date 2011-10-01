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
  let(:billy) { create(:billy) }

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
      page.markup = "##H2 Heading#\n *Bold*"
      page.save.should be_true
      page.body.should include('<h2>H2 Heading</h2>')
      page.body.should include('<em>Bold</em>')
    end
    
    it "should not sanitize whitelisted tags" do
      hash = Sanitize::Config::CUSTOM
      whitelist = hash[:elements]
      whitelist.each do |tag|
        page.markup = "<#{tag}>"
        page.save.should be_true
        page.body.should include("<#{tag}>")
      end
    end
    
    it "should sanitize embedded tags" do
      page.markup = "<a <script> alert(\"you have been hacked\")</script>>"
      page.save.should be_true
      page.body.should_not include("<script>")
    end 
     
    it "should sanitize tags not on the whitelist" do
      hash = Sanitize::Config::BLACK
      blacklist = hash[:elements]
      blacklist.each do |tag|
        page.markup = "<#{tag}>"
        page.save.should be_true
        page.body.should_not include("<#{tag}>")
      end
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
  
  describe "character_is_valid_for_user_profile" do
    it "should allow a user's character" do
      build(:page, :page_space_id => DefaultObjects.general_page_space.id, 
          :user_profile_id => billy.user_profile.id,
          :character_proxy_id => billy.character_proxies.first).should be_valid
    end
    it "should not allow a non user's character" do
      another_user_profile = create(:user_profile_with_characters)
      character_proxy_target = another_user_profile.character_proxies.first
      build(:page, :page_space_id => DefaultObjects.general_page_space.id, 
          :user_profile_id => billy.user_profile.id,
          :character_proxy_id => another_user_profile.character_proxies.first).should_not be_valid
    end
  end
end
