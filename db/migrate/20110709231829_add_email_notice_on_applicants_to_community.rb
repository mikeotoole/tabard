class AddEmailNoticeOnApplicantsToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :email_notice_on_applicant, :boolean
  end

  def self.down
    remove_column :communities, :email_notice_on_applicant
  end
end
