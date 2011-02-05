class Game < ActiveRecord::Base
 has_many :GameAnnouncements
 has_many :characters, :dependent => :destroy
 has_many :game_profiles, :dependent => :destroy
 has_many :discussion_spaces
 
 validates_presence_of :name
 
 after_create :create_game_discussion_space
 
 def create_game_discussion_space
   discussion_space = DiscussionSpace.create :name => self.name+" Announcements",
                                             :system => true,
                                             :game => self
   self.announcement_space_id = discussion_space.id
 end
 
 def announcement_space
   DiscussionSpace.find_by_id(self.announcement_space_id)
 end
 
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

end
