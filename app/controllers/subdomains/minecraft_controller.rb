###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for minecraft.
###
class Subdomains::MinecraftController < SubdomainsController
  def whitelist
    raise CanCan::AccessDenied unless current_user.owns_community?(current_community)
    @content = current_community.get_current_community_roster(Minecraft.first).map(&:name).join("\n")
    file_name = "export.txt"
    send_data @content,
      type: 'text',
      filename: "white-list.txt"
  end
end
