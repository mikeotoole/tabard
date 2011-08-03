=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents an announcement.
=end
class Announcement < ActiveRecord::Base
  #attr_accessible :name, :body, :comments_enabled

  belongs_to :user_profile  
  has_many :acknowledgment_of_announcements, :dependent => :destroy
  
  after_create :create_acknowledgments

=begin
  _after_create_
  
  This method is the default after_create method that is defined for all announcements.
  [Returns] A boolean indicating if the acknowledgments were created successfuly.
=end
  def create_acknowledgments
    true
  end  
  
=begin
  This method gets the name of the author for this announcement.
  [Returns] The display_name of the user_profile for this announcement.
=end
  def author_name
    self.user_profile.display_name
  end

=begin
  This method gets a snippet of the body for this announcement.
  [Args]
    * +n+ -> The number of words to include in the snippet. This defaults to 30.
  [Returns] The snippet from the body of this announcement.
=end
  def snippet(n=30)
    snippet = (self.body.split(' ')[0,n].inject{|sum,word| sum + ' ' + word}).to_s
    snippet.length < self.body.length ? snippet << '&hellip;' : snippet
  end

=begin
  This method gets the select options for announcements.
  [Returns] A sorted array of the descendants for announcements.
=end  
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end
end

# == Schema Information
#
# Table name: announcements
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  body             :text
#  user_profile_id  :integer
#  game_id          :integer
#  community_id     :integer
#  type             :string(255)
#  comments_enabled :boolean         default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#

