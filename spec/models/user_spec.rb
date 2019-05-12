require 'rails_helper'

VALID_USERNAME = 'User 1'
VALID_USERNAME2 = 'User 2'
VALID_PASSWORD = 'password123'
VALID_PASSWORD2 = 'password1234'
VALID_FIRST_NAME = 'User'
VALID_FIRST_NAME2 = 'User2'
VALID_LAST_NAME = 'Name'
VALID_LAST_NAME2 = 'Name2'
VALID_EMAIL = 'user1@example.com'
VALID_EMAIL2 = 'user2@example.com'

VALID_USER = {
    :username => VALID_USERNAME,
    :password => VALID_PASSWORD,
    :reset_token => SecureRandom.uuid,
    :first_name => VALID_FIRST_NAME,
    :last_name => VALID_LAST_NAME,
    :email => VALID_EMAIL
}

VALID_USER2 = {
    :username => VALID_USERNAME2,
    :password => VALID_PASSWORD2,
    :reset_token => SecureRandom.uuid,
    :first_name => VALID_FIRST_NAME2,
    :last_name => VALID_LAST_NAME2,
    :email => VALID_EMAIL2
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

  it "is not valid without username" do
    attr = VALID_USER.clone.except(:username)
    expect(User.new(attr)).to_not be_valid
  end

  it "is not valid without password" do
    attr = VALID_USER.clone.except(:password)
    expect(User.new(attr)).to_not be_valid
  end

  it "is not valid without first name" do
    attr = VALID_USER.clone.except(:first_name)
    expect(User.new(attr)).to_not be_valid
  end

  it "is not valid without last name" do
    attr = VALID_USER.clone.except(:last_name)
    expect(User.new(attr)).to_not be_valid
  end

  it "is not valid without email" do
    attr = VALID_USER.clone.except(:email)
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows duplicate username" do
    attr1 = VALID_USER.clone
    attr2 = VALID_USER2.clone

    attr1[:username] = VALID_USERNAME
    attr2[:username] = VALID_USERNAME

    user1 = User.new(attr1)
    expect(user1).to be_valid
    user1.save

    user2 = User.new(attr2)
    expect(user2).to_not be_valid
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

  it "disallows short username" do
    attr = VALID_USER.clone
    attr[:username] = 'w'
    expect(User.new(attr)).to_not be_valid
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

  it "disallows empty first name" do
    attr = VALID_USER.clone
    attr[:first_name] = ''
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows only spaces in first name" do
    attr = VALID_USER.clone
    attr[:first_name] = ' ' * 10
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows empty last name" do
    attr = VALID_USER.clone
    attr[:last_name] = ''
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows only spaces in last name" do
    attr = VALID_USER.clone
    attr[:last_name] = ' ' * 10
    expect(User.new(attr)).to_not be_valid
  end

  it "disallows incorrect email format" do
    attr = VALID_USER.clone
    attr[:email] = 'abcdefg@hijklmnop'
    expect(User.new(attr)).to_not be_valid
  end

  it "allows password authentication" do
    attr = VALID_USER.clone
    attr[:username] = VALID_USERNAME
    attr[:password] = VALID_PASSWORD
    User.create(attr)

    user = User.find_by_username(VALID_USERNAME)
    expect(user.authenticate(VALID_PASSWORD)).to be user
    expect(user.authenticate(VALID_PASSWORD2)).to be false

  end

  it "correctly changes password" do
    attr = VALID_USER.clone
    expect(User.new(attr)).to be_valid
    User.create(attr)

    # Test with original password
    user = User.find_by_username(VALID_USERNAME)
    expect(user.authenticate(VALID_PASSWORD)).to be user
    expect(user.authenticate(VALID_PASSWORD2)).to be false

    # Update password of user
    user.update_password(VALID_PASSWORD2)
    user.save

    # Check to make sure new password is being used
    user = User.find_by_username(VALID_USERNAME)
    expect(user.authenticate(VALID_PASSWORD)).to be false
    expect(user.authenticate(VALID_PASSWORD2)).to be user
  end
end
