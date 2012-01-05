# == Schema Information
#
# Table name: pages
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  markup             :text
#  page_space_id      :integer
#  show_in_navigation :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#  deleted_at         :datetime
#

require 'spec_helper'

describe Page do
  let(:page) { create(:page) }
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
  
  describe "destroy" do
    pending
  end
end
