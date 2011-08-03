class Game < ActiveRecord::Base
  #attr_accessible :name, :is_active, :announcement_space_id, :character_discussion_space
  #attr_accessible :game_announcements, :game_profiles, :discussion_spaces, :page_spaces, :supported_games
  #attr_accessible :type_helper
  
 has_many :game_announcements
 has_many :game_profiles, :dependent => :destroy
 has_many :discussion_spaces
 has_many :page_spaces
 has_many :supported_games
 has_many :communities, :through => :supported_games
 
 validates_presence_of :name
 
 after_create :create_game_discussion_space, :create_character_discussion_space
 
 scope :active, :conditions => {:is_active => true}
 
 def create_game_discussion_space
   discussion_space = DiscussionSpace.create( :name => self.name+" Announcements",
                                             :system => true,
                                             :game => self,
                                             :announcement_space => true)
   self.announcement_space_id = discussion_space.id
   self.save
 end
 
 def create_character_discussion_space
   discussion_space = DiscussionSpace.create( :name => self.name+" Characters",
                                             :system => true,
                                             :game => self)
   self.character_discussion_space_id = discussion_space.id
   self.save
 end
 
 def announcement_space
   DiscussionSpace.find_by_id(self.announcement_space_id)
 end
 
 def character_discussion_space
   DiscussionSpace.find_by_id(self.character_discussion_space_id)
 end
 
  # def self.active
  #   Game.where("is_active = ?", true)
  # end
 
 # Lets the subclasses use the parents routes. 
  def self.inherited(child)
    child.instance_eval do
      def model_name
        Game.model_name
      end
    end
    super
  end
 
  # Used to offer a dynamically generated list of subclass to choose from. 
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end

  def type_helper
    self.type
  end
  def type_helper=(type)
    self.type = type
  end

  def check_user_show_permissions(user)
    user.can_show("Game")
  end
  
  def check_user_create_permissions(user)
    user.can_create("Game")
  end
  
  def check_user_update_permissions(user)
    user.can_update("Game")
  end
  
  def check_user_delete_permissions(user)
    user.can_delete("Game")
  end
end

# == Schema Information
#
# Table name: games
#
#  id                            :integer         not null, primary key
#  name                          :string(255)
#  created_at                    :datetime
#  updated_at                    :datetime
#  type                          :string(255)
#  is_active                     :boolean
#  announcement_space_id         :integer
#  character_discussion_space_id :integer
#

