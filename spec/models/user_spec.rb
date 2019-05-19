require 'rails_helper'

VALID_EMAIL = 'user1@example.com'
VALID_EMAIL2 = 'user2@example.com'
VALID_PASSWORD = 'password123'
VALID_PASSWORD2 = 'password1234'
VALID_DISPLAY_NAME = 'User One'
VALID_DISPLAY_NAME2 = 'User Two'

VALID_USER = {
    :email => VALID_EMAIL,
    :password => VALID_PASSWORD,
    :reset_token => SecureRandom.uuid,
    :display_name => VALID_DISPLAY_NAME
}

VALID_USER2 = {
    :email => VALID_EMAIL2,
    :password => VALID_PASSWORD2,
    :reset_token => SecureRandom.uuid,
    :display_name => VALID_DISPLAY_NAME2
}

RSpec.describe User, type: :model do
  it "allows creation" do
    user = User.new(VALID_USER)
    expect(user).to be_valid
    expect {
      user.save
    }.to change { User.count }

  end

  it "is not valid with empty fields" do
    expect(User.new).to_not be_valid
  end

  it "is not valid without password" do
    attr = VALID_USER.clone.except(:password)
    expect(User.new(attr)).to_not be_valid
  end

  it "is not valid without display name" do
    attr = VALID_USER.clone.except(:display_name)
    expect(User.new(attr)).to_not be_valid
  end

  it "is not valid without email" do
    attr = VALID_USER.clone.except(:email)
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows duplicate email" do
    attr1 = VALID_USER.clone
    attr2 = VALID_USER2.clone

    attr1[:email] = VALID_EMAIL
    attr2[:email] = VALID_EMAIL

    user1 = User.new(attr1)
    expect(user1).to be_valid
    user1.save

    user2 = User.new(attr2)
    expect(user2).to_not be_valid
  end

  it "disallows duplicate reset token" do
    attr1 = VALID_USER.clone
    attr2 = VALID_USER2.clone

    reset_token = SecureRandom.uuid

    attr1[:reset_token] = reset_token
    attr2[:reset_token] = reset_token

    user1 = User.new(attr1)
    expect(user1).to be_valid
    user1.save

    user2 = User.new(attr2)
    expect(user2).to_not be_valid
  end

  it "disallows short password" do
    attr = VALID_USER.clone
    attr[:password] = 'wwww'
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows long password" do
    attr = VALID_USER.clone
    attr[:password] = 'w' * 200
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows empty display name" do
    attr = VALID_USER.clone
    attr[:display_name] = ''
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows only spaces in display name" do
    attr = VALID_USER.clone
    attr[:display_name] = ' ' * 10
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows incorrect email format" do
    attr = VALID_USER.clone
    attr[:email] = 'abcdefg@hijklmnop'
    expect(User.new(attr)).to_not be_valid
  end

  it "allows password authentication" do
    attr = VALID_USER.clone
    attr[:email] = VALID_EMAIL
    attr[:password] = VALID_PASSWORD
    User.create(attr)

    user = User.find_by_email(VALID_EMAIL)
    expect(user.authenticate(VALID_PASSWORD)).to be user
    expect(user.authenticate(VALID_PASSWORD2)).to be false

  end

  it "correctly changes password" do
    attr = VALID_USER.clone
    expect(User.new(attr)).to be_valid
    User.create(attr)

    # Test with original password
    user = User.find_by_email(VALID_EMAIL)
    expect(user.authenticate(VALID_PASSWORD)).to be user
    expect(user.authenticate(VALID_PASSWORD2)).to be false

    # Update password of user
    user.update_password(VALID_PASSWORD2)
    user.save

    # Check to make sure new password is being used
    user = User.find_by_email(VALID_EMAIL)
    expect(user.authenticate(VALID_PASSWORD)).to be false
    expect(user.authenticate(VALID_PASSWORD2)).to be user
  end

  it "correctly updates name" do
    attr = VALID_USER.clone
    expect(User.new(attr)).to be_valid
    User.create(attr)

    # Test with original profile
    user = User.find_by_email(VALID_EMAIL)
    expect(user.display_name).to eq VALID_DISPLAY_NAME

    # Update name of user
    user.update(:display_name => VALID_DISPLAY_NAME2)
    expect(user).to be_valid
    user.save

    # Check to make sure new name is being used
    user = User.find_by_email(VALID_EMAIL)
    expect(user.display_name).to eq VALID_DISPLAY_NAME2
  end
end
