class DocumentSweeper < ActionController::Caching::Sweeper
  observe Document
  
  def sweep(document)
    expire_page top_level_privacy_policy_path
    expire_page top_level_terms_of_service_path
  end
  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep
end