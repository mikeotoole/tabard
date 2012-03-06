###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is a sweeper for documents.
###
class DocumentSweeper < ActionController::Caching::Sweeper
  observe Document
  
  # Sweeps the document
  def sweep(document)
    expire_page top_level_privacy_policy_path
    expire_page top_level_terms_of_service_path
  end
  # Sweeps the document
  alias_method :after_create, :sweep
  # Sweeps the document
  alias_method :after_update, :sweep
  # Sweeps the document
  alias_method :after_destroy, :sweep
end