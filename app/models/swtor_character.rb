=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This class represents a Star Wars the Old Republic character.
=end
class SwtorCharacter < BaseCharacter
  attr_accessor :avatar, :avatar_cache
  #attr_accessible :name, :server, :game, :discussion
  
  belongs_to :swtor, :foreign_key => :game_id
  
  validates_presence_of :swtor
  
  #uploaders
  mount_uploader :avatar, AvatarUploader
  #uploader helper
  def remove_avatar!
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
    end
  end
  def remove_previously_stored_avatar
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
      @previous_model_for_avatar = nil
    end
  end
  
  def display_name
    self.name
  end
  
  def game
    self.swtor
  end
  
  def description
    "SWTOR Character"
  end    
  
end

# == Schema Information
#
# Table name: swtor_characters
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  server        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  game_id       :integer
#  discussion_id :integer
#  avatar        :string(255)
#

