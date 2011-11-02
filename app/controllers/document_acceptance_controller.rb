class DocumentAcceptanceController < ApplicationController

  skip_before_filter :ensure_accepted_most_recent_legal_documents
  before_filter :find_document, :only => [:new, :create]

  def new
    if current_user.accepted_documents.include?(@document)
      redirect_to user_root_path, :notice => "You have already accepted Document"
    end
  end

  def create
    if current_user.accepted_documents.include?(@document)
      redirect_to user_root_path, :notice => "You have already accepted the document."
    elsif params[:accept]
      current_user.accepted_documents << @document
      case @document.type
      when "TermsOfService"
        current_user.update_attribute(:accepted_current_terms_of_service, true)
      when "PrivacyPolicy"
        current_user.update_attribute(:accepted_current_privacy_policy, true)
      end
      redirect_to user_root_path, :notice => "The document has been accepted."
    else
      flash[:alert] = "You must accept this document to continue using Crumblin."
      render :new
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
