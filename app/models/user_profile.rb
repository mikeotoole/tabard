require 'file_size_validator'
class UserProfile < Profile
  attr_accessible :avatar, :avatar_cache, :remove_avatar
  attr_accessible :name
  
  validates :avatar, 
      :if => :avatar?, 
      :file_size => { 
        :maximum => 1.megabytes.to_i 
      }
  
  belongs_to :user

  has_many :game_profiles, :autosave => true
  
  has_one :registration_application
  
  belongs_to :discussion
  belongs_to :personal_discussion_space, :class_name => "DiscussionSpace"

  has_many :sent_messages, :class_name => "Message", :foreign_key => "author_id"
  has_many :received_messages, :class_name => "MessageCopy", :foreign_key => "recipient_id"
  has_many :folders
  
  has_many :notifications
  has_many :site_form_notifications, :through => :notification, :source => :site_form

  before_create :build_inbox
  after_create :create_discussion, :create_personal_space
  
  #uploaders
  mount_uploader :avatar, AvatarUploader
  
  # User can only have one user profile
  validates_uniqueness_of :user_id
  validate :only_one_system_profile
  
  #This will add a new character, creating the game profile if needed.
  def build_character(character, is_default = false) 
    
    self.game_profiles.each do |game_profile|
      if game_profile.game_id == character.game_id       
        proxy = game_profile.character_proxies.build(:character => character)
        game_profile.default_character_proxy = proxy if is_default and proxy
        return true
      end
    end
    
    # create new game profile
    game_profile = GameProfile.new(:game => character.game, :name => "#{self.name} #{character.game.name} Profile", :user_profile => self)
    game_profile.character_proxies.build(:character => character)
    self.game_profiles << game_profile
  end
  
  def get_characters(game)
    self.game_profiles.collect{|gPro| 
       gPro.characters if gPro.game.kind_of? game
    }.flatten.compact
  end
  
  def only_one_system_profile
    errors.add(:id, "There can be only one!  ...system profile.") if (UserProfile.where(:is_system_profile => true).exists? and self.is_system_profile)
  end
  
  def self.system_profile
    if self.where(:is_system_profile => true).exists?
      return self.where(:is_system_profile => true).first
    else
      return self.create(:name => "System", :is_system_profile => true, :status => 0)
    end
  end
  
  def inbox
    folders.find_by_name("Inbox")
  end

  def build_inbox
    folders.build(:name => "Inbox")
  end
  
  def deleted_received_messages
    self.received_messages.delete_if {|message| message.deleted == false or message.deleted == nil}
  end
  
  #TODO Can this be implemented better?
  def characters
     characters = Array.new()
     for game_profile in self.game_profiles
       for chara in game_profile.characters
         characters << chara
       end
     end
     characters
  end
  
  def displayname
    self.display_name # TODO This needs to be depricated because it is bad namming of a method.
  end
  
  def display_name
    self.name
  end
  
  def description
    "Account Profile"
  end  
  
  # Used by active profile to see selected item is a user profile
  # def character_id
  #   -1
  # end
  
  def create_discussion
    self.discussion = Discussion.create(:discussion_space => DiscussionSpace.user_profile_space,
                                        :name => self.displayname,
                                        :body => "User Profile Discussion",
                                        :user_profile => self) unless self.is_system_profile
  end
  
  def create_personal_space
    self.personal_discussion_space = DiscussionSpace.create(:name => self.displayname.to_s+" Personal Discussion Space",
                                        :system => true,
                                        :personal_space => true,
                                        :user_profile => self) unless self.is_system_profile
    self.save
  end
  
  def check_user_show_permissions(user)
    user.can_show("User") or self == user.user_profile
  end
  
  def check_user_create_permissions(user)
    user.can_create("User") or self == user.user_profile
  end
  
  def check_user_update_permissions(user)
    user.can_update("User") or self == user.user_profile
  end
  
  def check_user_delete_permissions(user)
    user.can_delete("User") or self == user.user_profile
  end
end
