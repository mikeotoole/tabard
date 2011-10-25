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

