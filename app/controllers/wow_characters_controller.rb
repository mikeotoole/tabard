###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for World of Warcraft characters.
###
class WowCharactersController < CharactersController
  load_and_authorize_resource

  def edit
    @character = @wow_character
  end

  def update
    @wow_character.update_attributes(params[:wow_character])
    redirect_to user_profile_url(current_user, anchor: "games", subdomain: "www")
  end
end
