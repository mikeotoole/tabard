=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This class represents an Base Character that all others are extended from.
=end
class BaseCharacter < ActiveRecord::Base
  self.abstract_class = true
  #attr_accessible :game, :discussion

  belongs_to :game
  belongs_to :discussion
  has_one :character_proxy, :as => :character, :dependent => :destroy, :foreign_key => :character_id

  validates_presence_of :name, :game

  #after_create :create_discussion

=begin
  This method returns the id of this character's character proxy.
  [Returns] An integer that contains the id for this character's character proxy, if possible, otherwise nil.
=end
  def character_proxy_id
    return self.character_proxy.id if self.character_proxy
    nil
  end

=begin
  This method returns the id of this character.
  [Returns] An integer that contains the id for this character.
=end
  def character_id
    self.id
  end

=begin
  This method returns the display name of this character.
  [Returns] A string that contains the display name for this character.
=end
  def display_name
    ""
  end

  #def create_discussion
  #  return if self.discussion
  #  user_profile = self.character_proxy.game_profile.user_profile if self.character_proxy and self.character_proxy.game_profile
  #  self.discussion = Discussion.create(:discussion_space => game.character_discussion_space,
  #                                      :name => self.name,
  #                                      :body => "Character Discussion",
  #                                      :user_profile => user_profile)
  #                                      # :character_proxy_id => self.character_proxy.id,
  #end

# TODO Mike needs to comment it.
  def default
    self.character_proxy_id == self.character_proxy.game_profile.default_character_proxy_id
  end

  # Lets the subclasses use the parents routes.
  # def self.inherited(child)
  #   child.instance_eval do
  #     def model_name
  #       BaseCharacter.model_name
  #     end
  #   end
  #   super
  # end

  # def self.factory(class_name, params = nil)
  #   class_name << "Character"
  #   if defined? class_name.constantize
  #     class_name.constantize.new(params)
  #   else
  #     Character.new(params)
  #   end
  # end

=begin
  This method defines how show permissions are determined for this base character.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can show this base character, otherwise false.
=end
  def check_user_show_permissions(user)
    return true
  end

=begin
  This method defines how create permissions are determined for this base character.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can create this base character, otherwise false.
=end
  def check_user_create_permissions(user)
    return true
  end

=begin
  This method defines how update permissions are determined for this base character.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can update this base character, otherwise false.
=end
  def check_user_update_permissions(user)
    self.character_proxy.game_profile.user_profile.id == user.user_profile.id or user.can_update("Character")
  end

=begin
  This method defines how delete permissions are determined for this base character.
  [Args]
    * +user+ -> The user who you would like to check.
  [Returns] True if the provided user can delete this base character, otherwise false.
=end
  def check_user_delete_permissions(user)
    self.character_proxy.game_profile.user_profile.id == user.user_profile.id or user.can_delete("Character")
  end
end
