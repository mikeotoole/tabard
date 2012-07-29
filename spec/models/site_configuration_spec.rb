# == Schema Information
#
# Table name: site_configurations
#
#  id             :integer          not null, primary key
#  is_maintenance :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe SiteConfiguration do
  describe "current_configuration" do
    it "should create or find the only configuration" do
      Rails.cache.delete('SiteConfiguration.first')
      SiteConfiguration.all.size.should eq 0
      @config = SiteConfiguration.current_configuration
      SiteConfiguration.all.size.should eq 1
      @config2 = SiteConfiguration.current_configuration
      SiteConfiguration.all.size.should eq 1
      @config.should eq @config2
    end
  end

  describe "destroy" do
    it "should delete SiteConfiguration" do
      configuration = SiteConfiguration.create!
      SiteConfiguration.all.size.should eq 1
      configuration.destroy
      SiteConfiguration.exists?(configuration).should be_false
    end
  end
end
