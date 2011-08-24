=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents a page space.
=end
class PageSpace < ActiveRecord::Base
  #attr_accessible :name, :game, :community, :pages

  has_many :pages, :dependent => :destroy
  belongs_to :game
  belongs_to :community

=begin
  This method gets the name of the game that this page space belongs to.
  [Returns] The name of the game this page space belongs to, if possible, otherwise nil.
=end
  def game_name
    return self.game.name if self.game
    nil
  end

=begin
  This method defines how show permissions are determined for this page spage.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this page space, otherwise false.
=end
  def check_user_show_permissions(user)
    return true
  end

=begin
  This method defines how create permissions are determined for this page spage.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this page space, otherwise false.
=end
  def check_user_create_permissions(user)
    user.can_create("PageSpace")
  end

=begin
  This method defines how update permissions are determined for this page spage.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this page space, otherwise false.
=end
  def check_user_update_permissions(user)
    user.can_update("PageSpace")
  end

=begin
  This method defines how delete permissions are determined for this page spage.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this page space, otherwise false.
=end
  def check_user_delete_permissions(user)
    user.can_delete("PageSpace")
  end
end

# == Schema Information
#
# Table name: page_spaces
#
#  id           :integer         not null, primary key
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string(255)
#  game_id      :integer
#  community_id :integer
#

