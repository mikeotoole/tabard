class DocumentAcceptanceController < ApplicationController

  skip_before_filter :ensure_accepted_most_recent_legal_documents
  before_filter :find_document, :hide_all_annoucements, :only => [:new, :create]

  def new
    if current_user.accepted_documents.include?(@document)
      redirect_to user_root_path, :notice => "You have already accepted Document"
    end
    add_new_flash_message('You must accept the updated "Terms of Service" to continue to use Crumblin.', "alert") unless current_user.accepted_current_terms_of_service
    add_new_flash_message('You must accept the updated "Privacy Policy" to continue to use Crumblin.', "alert") unless current_user.accepted_current_privacy_policy
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
  
  def hide_all_annoucements
    @hide_announcements = true
  end
end
