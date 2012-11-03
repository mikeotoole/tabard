###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for Minecraft characters.
###
class MinecraftCharactersController < CharactersController
  load_and_authorize_resource

  def edit
    @character = @minecraft_character
  end

  def update
    @minecraft_character.update_attributes(params[:minecraft_character])
    redirect_to user_profile_url(current_user, anchor: "games", subdomain: "www")
  end
end
