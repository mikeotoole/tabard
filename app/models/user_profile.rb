class UserProfile < Profile
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
  
  
  # User can only have one user profile
  validates_uniqueness_of :user_id
  validate :only_one_system_profile
  
  def build_character(character, is_default = false) 
    
    self.game_profiles.each do |game_profile|
      if game_profile.game_id == character.game_id       
        proxy = game_profile.character_proxies.build(:character => character)
        game_profile.default_character_proxy = proxy if is_default and proxy
        return true
      end
    end
    
    # create new game profile
    game_profile = GameProfile.new(:game => character.game, :name => "#{self.name} #{character.game.name} Profile")
    game_profile.character_proxies.build(:character => character)
    self.game_profiles << game_profile
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
  
  def status_string
    if is_applicant
      "Applicant"
    elsif is_active
      "Active User"
    elsif is_inactive
      "Deactivated User"
    elsif is_rejected
      "Rejected"  
    else
      "Unknown"
    end
  end
  
  def is_applicant
    if self.status == 1
      return true
    else
      return false
    end
  end
  
  def is_active
    if self.status == 2
      return true
    else
      return false  
    end
  end
  
  def is_inactive
    if self.status == 3
      return true
    else
      return false  
    end   
  end
  
  def is_rejected
    if self.status == 4
      return true
    else
      return false  
    end   
  end
  
  def set_applicant
    self.status = 1
  end
  
  def set_active
    self.status = 2
  end
  
  def set_inactive
    self.status = 3   
  end
  
  def set_rejected
    self.status = 4
  end
  
  # This is confusing because we have something called an active profile. 
  # But this returns all the user profiles that have an active status. -MO
  def self.active_profiles
    UserProfile.find(:all, :conditions => {:status => 2})
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
  
end
