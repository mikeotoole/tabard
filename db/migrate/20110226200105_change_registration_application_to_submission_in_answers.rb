class ChangeRegistrationApplicationToSubmissionInAnswers < ActiveRecord::Migration
  def self.up
    remove_column :answers, :registration_application_id
    add_column :answers, :submission_id, :integer
  end

  def self.down
    remove_column :answers, :submission_id
    add_column :answers, :registration_application_id, :integer
  end
end
