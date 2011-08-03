class Swtor < Game
   has_many :swtor_characters, :foreign_key => :game_id, :dependent => :destroy
   
  def characters
    self.swtor_characters
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

