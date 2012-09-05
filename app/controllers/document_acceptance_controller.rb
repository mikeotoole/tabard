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
    if current_user.accepted_documents.include?(@document) and current_user.document_acceptances.find_by_document_id(@document.id).is_current
      current_user.update_acceptance_of_documents(@document)
      redirect_to user_profile_url(current_user.user_profile), notice: "You have already accepted the document"
    end
    flash[:alert] = "You must accept the updated \"Terms of Service\" to continue to use Tabard&trade;." unless current_user.accepted_current_terms_of_service
    flash[:alert] = "You must accept the updated \"Privacy Policy\" to continue to use Tabard&trade;." unless current_user.accepted_current_privacy_policy
  end

  # POST /accept_document/:id(.:format)
  def create
    if current_user.accepted_documents.include?(@document) and current_user.document_acceptances.find_by_document_id(@document.id).is_current
      current_user.update_acceptance_of_documents(@document)
      redirect_to user_profile_url(current_user.user_profile), notice: "You have already accepted the document."
    elsif params[:accept]
      current_user.accepted_documents << @document unless current_user.accepted_documents.include?(@document)
      current_user.update_acceptance_of_documents(@document)
      redirect_to user_profile_url(current_user.user_profile), notice: "The document has been accepted."
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
