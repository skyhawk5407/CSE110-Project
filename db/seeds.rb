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
    User.create(
        :email => 'jsmith@example.com',
        :password => 'password123',
        :display_name => 'John Smith'
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