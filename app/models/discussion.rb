=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a discussion.
=end
class Discussion < ActiveRecord::Base
  #attr_accessible :name, :body, :comments_enabled, :has_been_locked
  #attr_accessible :user_profile, :character_proxy, :discussion_space, :comments, :game
  
  belongs_to :user_profile
  belongs_to :character_proxy
  belongs_to :discussion_space
  belongs_to :game
  has_many :comments, :as => :commentable
  has_one :community, :through => :discussion_space
  
  before_create :use_default_character
  
  def use_default_character
    return unless self.user_profile and self.respond_to?('game') and self.discussion_space and self.discussion_space.game
    self.user_profile.game_profiles.each do |game_profile|
      if(game_profile.game.id == self.discussion_space.game.id)
        self.character_proxy_id = game_profile.default_character_proxy_id
      end
    end
  end
  
  def users_name
    user_profile.displayname if user_profile
  end
  
  def character
    character_proxy.character if character_proxy
  end
  
  def characters_name
    character.name if character_proxy
  end
  
  def charater_posted?
    character != nil
  end
  
  def number_of_comments
   temp_total_num_comments = 0
   comments.each do |comment|
     temp_total_num_comments += comment.number_of_comments
   end 
   temp_total_num_comments
  end
  
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show(DiscussionSpace.find(self.discussion_space.id)) or user.can_show("Discussion")
  end
  
  def check_user_create_permissions(user)
    if(self.discussion_space)
      return user.can_create(DiscussionSpace.find(self.discussion_space.id))
    end
    user.can_create("Discussion")
  end
  
  def check_user_update_permissions(user)
    if has_been_locked 
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    user.can_update(DiscussionSpace.find(self.discussion_space.id)) or user.can_update("Discussion")
  end
  
  def check_user_delete_permissions(user)
    if has_been_locked 
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    #Hack
    user.can_delete(DiscussionSpace.find(self.discussion_space.id)) or user.can_delete("Discussion")
  end
  
  def can_user_lock(user)
    return true if user and user.user_profile == self.discussion_space.user_profile
    user.can_special_permissions("Discussion","lock")
  end
end

# == Schema Information
#
# Table name: discussions
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  body                :text
#  discussion_space_id :integer
#  character_proxy_id  :integer
#  user_profile_id     :integer
#  created_at          :datetime
#  updated_at          :datetime
#  type                :string(255)
#  game_id             :integer
#  comments_enabled    :boolean         default(TRUE)
#  has_been_locked     :boolean
#

