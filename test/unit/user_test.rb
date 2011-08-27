# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  failed_attempts        :integer         default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  ###
  # Fixtures
  ###
  fixtures :users

  ###
  # Validator Tests
  ###
  test "User creation validation presence test" do
    user = User.new
    assert user.invalid?, "should be an invalid user"
    assert user.errors[:email].any?, "should not allow blank email on creation."
    assert user.errors[:password].any?, "should not allow blank password on creation."
  end

  test "User creation validation email format and length test" do
    valid_password = "P@ssw0rd!"
    ok_emails = %w{ a@b.us lol@email.com } # TESTING Valid emails for testing.
    bad_emails = %w{ not_a_email herp@lol } # TESTING Invalid emails for testing.

    ok_emails.each do |email|
      assert new_user(valid_password, email).valid?, "#{email} shouldn't be invalid"
    end

    bad_emails.each do |email|
      assert new_user(valid_password, email).invalid?, "#{email} shouldn't be valid"
    end
  end

  test "User creation validation password format and length test" do
    valid_email = "unique@example.com"
    ok_passwords = %w{ p@ssword Password! #password !password @password 2password p4ssword Password pAssword l0ngP@ssword 1111111@ @1111111 1111$111 11111111P P1111111 p1111111 PPPPPPPP@ } # TESTING Valid passwords for testing.
    bad_passwords = %w{ password 11111111 PASSWORD !!!!!!!! short OMFINGGthispasswordiswaytoolongtobevalid } # TESTING Invalid passwords for testing.

    ok_passwords.each do |password|
      assert new_user(password, valid_email).valid?, "#{password} shouldn't be invalid"
    end

    bad_passwords.each do |password|
      assert new_user(password, valid_email).invalid?, "#{password} shouldn't be valid"
    end
  end

  test "User creation validation email uniqueness test" do
    user = User.new(:email => users(:billy).email,
        :password => "OMG@P4ssw0rd")
    assert !user.save, "emails should be unique"
    assert_equal I18n.translate('activerecord.error.message.taken'), user.errors[:email].join('; '), "error message should match activerecord taken message"
  end

  test "User update validation password, skip if blank" do
    user = users(:billy)
    assert user.password.blank?, "password should be blank on load"
    assert user.valid?, "should be valid on update"
  end

  ###
  # Method Tests
  ###
  # This Method is currently commented due to it's protection level, protected.
  #test "User password_required? method" do
  #  user = User.new
  #  assert user.password_required?, "password_required? should be true on a new user"
  #
  #  user = users(:billy)
  #  new_password = "l0lP@ssword"
  #  user.password = new_password
  #  user.password_confirmation = new_password
  #  assert user.password_required?, "password_required? should be true when password is blank"
  #
  #  user = users(:billy)
  #  asssert !user.password_required?, "password_required? should be false if the record is not new and password is blank"
  #end

  ###
  # This method is used to create new users.
  ###
  def new_user(password, email)
    User.new(:email => email,
        :password => password)
  end
end
