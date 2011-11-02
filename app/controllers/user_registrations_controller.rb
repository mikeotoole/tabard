# app/controllers/registrations_controller.rb
class UserRegistrationsController < Devise::RegistrationsController
  skip_before_filter :ensure_accepted_most_recent_legal_documents, :only => [:edit, :update]
end 