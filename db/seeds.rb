# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

case Rails.env
  when 'development'
    # development-specific seeds ...
    # (anything you need to interactively play around with in the rails console)
    apt = Apartment.create(
        :name => 'WHAADADUPUPP',
        :address => 'WHEREDIDTHESODAGO?!?!?!',
    )

    User.create(
        :email => 'jsmith@example.com',
        :password => 'password123',
        :display_name => 'John Smith',
        :apartment_id => apt.id
    )

    User.create(
        :email => 'yappa@example.com',
        :password => 'password234',
        :display_name => 'Yalta Appolo',
        :apartment_id => apt.id
    )

    User.create(
        :email => 'jxie@example.com',
        :password => 'password345',
        :display_name => 'Jonathan Xie',
        :apartment_id => apt.id
    )

    User.create(
        :email => 'theflash@example.com',
        :password => 'password456',
        :display_name => 'Barry Allen',
        :apartment_id => apt.id
    )

    User.create(
        :email => 'eyeager@example.com',
        :password => 'password567',
        :display_name => 'Eren Yeager',
        :apartment_id => apt.id
    )

  when 'test'
    # test-specific seeds ...
    # (Consider having your tests set up the data they need
    # themselves instead of seeding it here!)

  when 'production'
    # production seeds (if any) ...
  else pass
end

# common seeds ...
# (data your application needs in all environments)