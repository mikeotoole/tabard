class CommunitySweeper < ActionController::Caching::Sweeper
  observe Community
  
  def sweep(community)
    expire_page communities_path
    expire_page communities_path(product)
    FileUtils.rm_rf "#{page_cache_directory}/communities/page"
  end
  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end