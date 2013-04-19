###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is the controller for document acceptance. It handles the accpentance of documents by users.
###
class DocumentAcceptanceController < ApplicationController

  skip_before_filter :ensure_accepted_most_recent_legal_documents
  before_filter :find_document, only: [:new, :create]

  # GET /accept_document/:id(.:format)
  def new
    if current_user.has_accepted_the_document(@document)
      redirect_to user_profile_url(current_user.user_profile), notice: "You have already accepted the document"
    end
    flash.now[:alert] = "You must accept the updated \"Terms of Service\" to continue to use Tabard&trade;." if not current_user.accepted_current_terms_of_service and @document.class == TermsOfService
    flash.now[:alert] = "You must accept the updated \"Privacy Policy\" to continue to use Tabard&trade;." if not current_user.accepted_current_privacy_policy and @document.class == PrivacyPolicy
  end

  # POST /accept_document/:id(.:format)
  def create
    if current_user.has_accepted_the_document(@document.id)
      current_user.update_acceptance_of_documents(@document)
      redirect_to user_profile_url(current_user.user_profile), notice: "You have already accepted the document."
    elsif params[:accept]
      current_user.update_acceptance_of_documents(@document)
      redirect_to user_profile_url(current_user.user_profile)
    else
      ensure_accepted_most_recent_legal_documents
    end
  end

###
# Callback Methods
###
  ###
  # _before_filter
  #
  # This before filter attempts to create @community_application from: community_applications.new(params[:community_application]) or community_applications.new(), for the current community.
  ###
  def find_document
    @document = Document.find_by_id(params[:id])
  end
end
