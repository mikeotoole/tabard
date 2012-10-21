###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents the assocation between a message and a user of the acceptance of a document.
###
class DocumentAcceptance < ActiveRecord::Base
  validates_lengths_from_database
  belongs_to :user
  belongs_to :document

  scope :most_recent, order(:created_at).reverse_order.limit(1)
end

# == Schema Information
#
# Table name: document_acceptances
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  document_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_current  :boolean          default(TRUE)
#

