=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents an acknowledgement of an announcement. It connects profiles with announcements.
=end
class AcknowledgmentOfAnnouncement < ActiveRecord::Base
  #Accessors

  #Associations
  belongs_to :announcement
  belongs_to :profile

  #Validators
  validates :announcement_id, :presence => true
  validates :profile_id, :presence => true

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
#  acknowledged    :boolean         default(FALSE)
#

