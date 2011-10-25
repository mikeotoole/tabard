class DocumentAcceptance < ActiveRecord::Base
	belongs_to :user
	belongs_to :document
end

# == Schema Information
#
# Table name: document_acceptances
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  document_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

