class SwtorCharacter < BaseCharacter
  attr_accessible :avatar, :avatar_cache
  attr_accessible :name, :server, :game, :discussion
  
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
  
  def game
    self.swtor
  end
  
  def description
    "SWTOR Character"
  end    
  
end
