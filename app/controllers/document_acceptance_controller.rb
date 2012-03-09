###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is the controller for document acceptance. It handles the accpentance of documents by users.
###
class DocumentAcceptanceController < ApplicationController

  skip_before_filter :ensure_accepted_most_recent_legal_documents
  before_filter :find_document, :hide_all_annoucements, :only => [:new, :create]

  # GET /accept_document/:id(.:format)
  def new
    if current_user.accepted_documents.include?(@document)
      current_user.update_attributes(:accepted_current_terms_of_service => true) if @document == TermsOfService.current
      current_user.update_attributes(:accepted_current_privacy_policy => true) if @document == PrivacyPolicy.current
      redirect_to user_profile_url(current_user.user_profile), :notice => "You have already accepted the document"
    end
    add_new_flash_message('You must accept the updated "Terms of Service" to continue to use Crumblin.', "alert") unless current_user.accepted_current_terms_of_service
    add_new_flash_message('You must accept the updated "Privacy Policy" to continue to use Crumblin.', "alert") unless current_user.accepted_current_privacy_policy
  end

  # POST /accept_document/:id(.:format)
  def create
    if current_user.accepted_documents.include?(@document)
      current_user.update_attributes(:accepted_current_terms_of_service => true) if @document == TermsOfService.current
      current_user.update_attributes(:accepted_current_privacy_policy => true) if @document == PrivacyPolicy.current
      redirect_to user_profile_url(current_user.user_profile), :notice => "You have already accepted the document."
    elsif params[:accept]
      current_user.accepted_documents << @document
      case @document.type
      when "TermsOfService"
        current_user.update_attribute(:accepted_current_terms_of_service, true)
      when "PrivacyPolicy"
        current_user.update_attribute(:accepted_current_privacy_policy, true)
      end
      redirect_to user_profile_url(current_user.user_profile), :notice => "The document has been accepted."
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

  ###
  # _before_filter
  #
  # This before filter tells the view to hide the display of announcements in the flash messages, which happens by default.
  ###
  def hide_all_annoucements
    @hide_announcements = true
  end
end
