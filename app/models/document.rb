###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Document that the user must accept to use crumblin.
###
class Document < ActiveRecord::Base
  default_scope :order => "version DESC"
  validates :body, :presence => true
  validates :version, :uniqueness => {:scope => :type}
  has_many :document_acceptances

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
      # Defines the subclasses model name as its base class Game.
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
        'Terms of Service'
      else
        self.type.scan(/[A-Z][a-z0-9]*/).join ' '
    end
  end
end

# == Schema Information
#
# Table name: documents
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  body       :text
#  version    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

