###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Minecraft character.
###
class MinecraftCharacter < Character

  def find_and_upload_avatar_from_game
    begin
      begin
        head_image = MiniMagick::Image.open("http://s3.amazonaws.com/MinecraftSkins/#{self.name}.png")
        hat_image = MiniMagick::Image.open("http://s3.amazonaws.com/MinecraftSkins/#{self.name}.png")
      rescue
        head_image = MiniMagick::Image.open("http://minecraft.net/skin/char.png")
        hat_image = MiniMagick::Image.open("http://minecraft.net/skin/char.png")
      end
      # (8,8,8,8) (48,8,8,8)
      head_image.crop("8x8+8+8")
      hat_image.crop("8x8+40+8")
      final_image = head_image.composite(hat_image) do |c|
        c.gravity "center"
      end
      final_image.sample("240x240")
      self.avatar = final_image
      self.save!
    rescue
    end
  end
end

# == Schema Information
#
# Table name: characters
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  avatar         :string(255)
#  about          :text
#  played_game_id :integer
#  info           :hstore
#  type           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_removed     :boolean
#

