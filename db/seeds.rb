# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Disable email while seeding
ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = false

def tc_seed
  apt = Apartment.create(
      :name => 'WHAADADUPUPP',
      :address => '9500 Gilman Dr, La Jolla, CA 92093',
      )
  apt.update(:access_code => '12345')

  puts 'Created apartment with access code 12345'


  user1 = User.create(
      :email => 'jsmith@example.com',
      :password => 'password123',
      :display_name => 'John Smith',
      :apartment_id => apt.id
  )

  user2 = User.create(
      :email => 'yappa@example.com',
      :password => 'password234',
      :display_name => 'Yalta Appolo',
      :apartment_id => apt.id
  )

  user3 = User.create(
      :email => 'jxie@example.com',
      :password => 'password345',
      :display_name => 'Jonathan Xie',
      :apartment_id => apt.id
  )

  user4 = User.create(
      :email => 'theflash@example.com',
      :password => 'password456',
      :display_name => 'Barry Allen',
      :apartment_id => apt.id
  )

  user5 = User.create(
      :email => 'eyeager@example.com',
      :password => 'password567',
      :display_name => 'Eren Yeager',
      :apartment_id => apt.id
  )

  user_ids = [user1, user2, user3, user4, user5].map {|x| x.id}

  puts 'Created users'

  Faker::Config.random = Random.new(42)
  rng = Random.new(42)

  notification1 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Stove',
      :message => 'Hey guys. Someone left the stove running overnight. Not cool guys. Please turn it off when you guys cook next time'
  )

  notification2 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Rent',
      :message => 'Hey guys, remember to pay your share of the rent soon.'
  )

  notification3 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Party',
      :message => "Hey everyone. I'm gonna have a party here from 5pm to 12am. We might be loud, so please let me know if there will be any issues with that."
  )


  notification4 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Leaving for the weekend',
      :message => 'Im gonna be gone for the weekend to visit my family. Just wanted to let you guys know.'
  )

  notification5 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Restaurant',
      :message => 'What time do you guys want to go out to celebrate?'
  )

  notification6 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Larry the Cable Guy',
      :message => 'Hey guys just as a reminder, Larry will be coming over to fix our internet and TV tomorrow.'
  )

  notification7 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Larry the Cable Guy',
      :message => 'Hey guys just as a reminder, Larry will be coming over to fix our internet and TV tomorrow.'
  )

  notification8 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Remember to clean our the sink',
      :message => "Hey guys remember to clean out the sink. There are so many dirty dishes in there that Im pretty sure that it's starting to mold"
  )

  notification9 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Darryl the Plumber',
      :message => "Hey guys Darryl will be coming over tomorrow to fix the plumbing. Don't use the bathroom until then."
  )

  notification10 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Missing socks',
      :message => 'Hey so Ive been missing some socks in the dryers. Has anyone been taking them?'
  )

  notification11 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'SPRING BREAK WHOOO',
      :message => 'LETS GO SPRING BREAK WHOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
  )

  notification12 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'SUN GOD WHOOOOOOO',
      :message => 'LETS GO SUN GOOD WHOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO'
  )

  notification13 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Subleasing',
      :message => 'If anyone has any plans to sublease their room, remember to run by it with Gary first'
  )

  notification14 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Coffee Table',
      :message => 'The sellers will be coming over to give us the coffee table. If anyone is going to be home at
    around 3pm please try to help bring it in'
  )

  notification15 = Notification.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :title => 'Jacket',
      :message => 'Theres a jacket on top of the washing machine. Anyone know whose it is?'
  )
  puts 'Created notifications'

  item1 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Toaster',
      :bought => true,
      :description => 'Toaster',
      )
  item2 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Kettle',
      :bought => true,
      :description => 'Kettle',
      )
  item3 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Spatula',
      :bought => true,
      :description => 'Spatula',
      )
  item4 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Toaster Oven',
      :bought => true,
      :description => 'Toaster Oven',
      )
  item5 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Tv',
      :bought => true,
      :description => 'Tv',
      )
  item6 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Coffee Table',
      :bought => true,
      :description => 'Coffee Table',
      )
  item7 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Couch',
      :bought => true,
      :description => 'Couch',
      )
  item8 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Strainer',
      :bought => true,
      :description => 'Strainer',
      )
  item9 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Shoe Rack',
      :bought => true,
      :description => 'Shoe Rack',
      )
  item10 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Blender',
      :bought => true,
      :description => 'Blender',
      )
  item11 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Bird Feeder',
      :bought => true,
      :description => 'Bird Feeder',
      )
  item12 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Pot',
      :bought => true,
      :description => 'Pot',
      )
  item13 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Pan',
      :bought => true,
      :description => 'Pan',
      )
  item14 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Fridge',
      :bought => true,
      :description => 'Fridge',
      )
  item15 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Kettle',
      :bought => true,
      :description => 'Kettle',
      )
  item16 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Foreman Grill',
      :bought => true,
      :description => 'Foreman Grill',
      )
  item17 = Item.create(
      :apartment_id => apt.id,
      :user_id => user_ids.sample(:random => rng),
      :name => 'Lamp',
      :bought => true,
      :description => 'Lamp',
      )

  puts 'Created items'

  40.times do |_|
    rand_users = user_ids.sample(2, :random => rng)
    rand_num = rng.rand
    expense_info = if rand_num < 0.5
                     {:title => 'Rent', :amount => 50000 + rng.rand(30000)}
                   elsif rand_num < 0.8
                     {:title => 'Groceries', :amount => 1000 + rng.rand(1000)}
                   else
                     {:title => 'Restaurant', :amount => 1000 + rng.rand(1000)}
                   end
    expense = Expense.create(
        :apartment_id => apt.id,
        :payer_id => rand_users[0],
        :issuer_id => rand_users[1],
        :title => expense_info[:title],
        :description => Faker::Lorem.sentence,
        :amount => expense_info[:amount],
        :paid => rng.rand < 0.5
    )
  end

  puts 'Created expenses'

  files = [
      {:filename => 'adentudmsnd.pdf', :title => 'Lease Addendum'},
      {:filename => 'lease.pdf', :title => 'Lease'},
      {:filename => 'rules.pdf', :title => 'Apartment Rules'},
      {:filename => 'room.jpg', :title => 'Living Room'}
  ]

  files.each do |x|
    file = File.open(File.join(Rails.root, 'db', 'seeddata', x[:filename]), 'rb') {|io| io.read}
    Document.create(
        :apartment_id => apt.id,
        :user_id => user_ids.sample(:random => rng),
        :title => x[:title],
        :apartmentwide => true,
        :file_data => {:io => StringIO.new(file), :filename => x[:filename]}
    )
  end

  puts 'Created documents'

  # Other seeds, not in the main apartment

  # Not in an apartment
  # noapartment@example.com
  # password123
  User.create(
      :email => 'noapartment@example.com',
      :password => 'password123',
      :display_name => 'Test NoApartment'
  )

  # In apartment with nothing
  # change@example.com
  # password123
  apt2 = Apartment.create(
      :name => 'Test Apartment',
      :address => 'Test Address',
      )
  User.create(
      :email => 'change@example.com',
      :password => 'password123',
      :display_name => 'Test Change',
      :apartment_id => apt2.id
  )

  # Account to be deleted, in an apartment
  # delete@example.com
  # password123
  apt3 = Apartment.create(
      :name => 'Test Apartment',
      :address => 'Test Address',
      )
  User.create(
      :email => 'delete@example.com',
      :password => 'password123',
      :display_name => 'Test Delete',
      :apartment_id => apt3.id
  )

  # Account for recovery, not in an apartment
  # turdmate@mailinator.com
  # password123
  User.create(
      :email => 'turdmate@mailinator.com',
      :password => 'password123',
      :display_name => 'Test Recovery'
  )

  # Account for leave apartment, is in an apartment
  # leave@example.com
  # password123
  apt4 = Apartment.create(
      :name => 'Test Apartment',
      :address => 'Test Address',
      )
  User.create(
      :email => 'leave@example.com',
      :password => 'password123',
      :display_name => 'Test Leave',
      :apartment_id => apt4.id
  )

  puts "Create misc. TC seeds"
end

case Rails.env
when 'development'
  # development-specific seeds ...
  # (anything you need to interactively play around with in the rails console)
  tc_seed
when 'test'
  # test-specific seeds ...
  # (Consider having your tests set up the data they need
  # themselves instead of seeding it here!)

when 'production'
  # production seeds (if any) ...
  tc_seed
else
  pass
end

# common seeds ...
# (data your application needs in all environments)
