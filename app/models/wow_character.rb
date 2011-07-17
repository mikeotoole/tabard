class WowCharacter < BaseCharacter
  attr_accessible :avatar, :avatar_cache
  attr_accessible :name, :faction, :race, :level, :server, :game, :discussion
  
  belongs_to :wow, :foreign_key => :game_id
  
  validates_presence_of :wow
  
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
  
  def game
    self.wow
  end
  
  def description
    "WoW Character"
  end  
  
end
