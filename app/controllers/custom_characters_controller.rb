###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is the custom character class.
###
class CustomCharactersController < CharactersController
  load_and_authorize_resource

  def update
    @custom_character.update_attributes(params[:custom_character])
    redirect_to user_profile_url(current_user, anchor: "played_games", subdomain: "www")
  end
end
