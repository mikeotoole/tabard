###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Document that the user must accept to use the service.
###
class Document < ActiveRecord::Base
  default_scope :order => "version DESC"

###
# Constants
###
  # The list of vaild game subclass types.
  VALID_TYPES =  %w(PrivacyPolicy TermsOfService ArtworkAgreement)

###
# Callbacks
###
  before_update :ensure_published_document_not_updated
  after_save :reset_user_acceptance

###
# Attribute accessible
###
  attr_accessible :body, :version, :is_published, :type

###
# Validators
###
  validates :body,  :presence => true
  validates :type,  :presence => true,
                    :inclusion => { :in => VALID_TYPES, :message => "%{value} is not currently a supported document type." }
  validates :version, :uniqueness => {:scope => :type}

###
# Associations
###
  has_many :document_acceptances

###
# Public Methods
###
  # Gets the number of times this document has been accepted.
  def acceptance_count
    self.document_acceptances.count
  end

###
# Class Methods
###
  ###
  # Lets the subclasses use the parents routes.
  # [Args]
  #   * +child+ -> The class to check if subclass.
  # [Returns] If is subclass of Game returns Game as model name.
  ###
  def self.inherited(child)
    child.instance_eval do
      # Defines the subclasses model name as its base class Document.
      def model_name
        Document.model_name
      end
    end
    super
  end

  # Creates a human readable document based on the document type
  def title
    case self.type
      when 'TermsOfService'
        'Terms of Service and User Agreement'
      when 'ArtworkAgreement'
        'Artwork Licensing Agreement'
      else
        self.type.scan(/[A-Z][a-z0-9]*/).join ' '
    end
  end

###
# Protected Methods
###
protected

###
# Validator Methods
###
  ###
  # before_update
  #
  # This method will check that the current document trying to be updated is not published.
  # [Returns] False if is_published is true, otherwise true.
  ###
  def ensure_published_document_not_updated
    if Document.find(self).is_published
      self.errors.add(:type, "This document has been published and can't be changed.")
      return false
    else
      return true
    end
  end

  ###
  # _after_save_
  #
  # Sets a user's acceptance of the Privacy Policy to false
  ###
  def reset_user_acceptance
    case self.type
      when 'TermsOfService'
        if self.id == TermsOfService.current.id
          User.update_all(:accepted_current_terms_of_service => false)
        end
      when 'PrivacyPolicy'
        if self.id == PrivacyPolicy.current.id
          User.update_all(:accepted_current_privacy_policy => false)
        end
    end
  end
end





# == Schema Information
#
# Table name: documents
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  body         :text
#  created_at   :datetime
#  updated_at   :datetime
#  version      :integer
#  is_published :boolean         default(FALSE)
#

