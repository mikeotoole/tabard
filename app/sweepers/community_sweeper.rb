###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is a sweeper for communities.
###
class CommunitySweeper < ActionController::Caching::Sweeper
  observe Community
  
  # Sweeps the community
  def sweep(community)
    expire_page communities_path
    expire_page communities_path(community)
    FileUtils.rm_rf "#{page_cache_directory}/communities/page"
  end
  # Sweeps the community
  alias_method :after_create, :sweep
  # Sweeps the community
  alias_method :after_update, :sweep
  # Sweeps the community
  alias_method :after_destroy, :sweep
end