###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is a custom Devise::FailureApp.
# It allows us to override where devise redirects to on an authentication needed error.
###
class CustomDeviseAuthFailure < Devise::FailureApp
  # This method determines the url to redirect to when a devise not authenticated error happens.
  def redirect_url
    return super unless [:user].include?(scope) #make it specific to a scope
    new_user_session_url(subdomain: 'secure')
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end