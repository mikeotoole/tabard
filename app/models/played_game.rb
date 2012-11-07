class PlayedGame < ActiveRecord::Base
  attr_accessible :game_id, :user_profile_id, :game_name
  belongs_to :game
  belongs_to :user_profile
  has_many :characters, dependent: :destroy, order: 'LOWER(name)', conditions: {is_removed: nil} #TODO: Is this needed??


  delegate :type, to: :game, prefix: true, allow_nil: true

  def game_name
    game.try(:name)
  end

  def game_name=(name)
    if name.present?
      some_game = Game.where(name: name).first
      some_game = CustomGame.where(name: name).first_or_create if some_game.blank?
      self.game = some_game
    end
  end

  def new_character(params)
    character = self.game.new_character(params)
    character.played_game = self
    return character
  end
end

# == Schema Information
#
# Table name: played_games
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  user_profile_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

