class SupportedGame < ActiveRecord::Base
  belongs_to :community
  belongs_to :game
end
