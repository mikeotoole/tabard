=begin
  Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Don't Steal Me Bro!
  
  This class represents an acknowledgement of an announcement. It connects profiles with announcements.
=end
class AcknowledgmentOfAnnouncement < ActiveRecord::Base  
  #attr_accessible :acknowledged
  
  belongs_to :announcement, :profile
  
=begin
  This method fetches the correct display name of the announcement author.
  [Returns] The display name of the author for the announcement of this acknowledgment.
=end
  def author_name
    self.announcement.author_name
  end
  
=begin
  This method fetches the display name of the profile attached to this acknowledgment announcement.
  [Returns] The name of the profile that is attached to this acknowledgment.
=end
  def profile_name
    self.profile.display_name
  end

=begin
  This method is a depricated alias to the announcement
  [Returns] The announcement for this acknowledgment.
=end
  def path
    self.annoncement
  end
  
=begin
  This method gets the title for this acknowledgment.
  [Returns] The name of the announcement for this acknowledgment.
=end
  def title
    self.announcement.name
  end

=begin
  This method gets the body for this acknowledgment.
  [Returns] The body of the announcement for this acknowledgment.
=end
  def body
    self.announcement.body
  end

=begin
  This method gets a snippet of the body for this acknowledgment.
  [Args]
    * +n+ -> The number of words to include in the snippet. This defaults to 30.
  [Returns] The snippet from the announcement for this acknowledgment.
=end  
  def snippet(n=30)
    self.announcement.snippet(n)
  end
  
end

# == Schema Information
#
# Table name: acknowledgment_of_announcements
#
#  id              :integer         not null, primary key
#  announcement_id :integer
#  profile_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  acknowledged    :boolean
#

