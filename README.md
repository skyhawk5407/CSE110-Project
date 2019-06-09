# TURDMate

| Branch        | Status        |
| ------------- |:-------------:|
| master      | [![Build Status](https://travis-ci.org/tangandrew/CSE110-Project.svg?branch=master)](https://travis-ci.org/tangandrew/CSE110-Project) |
| rails      | [![Build Status](https://travis-ci.org/tangandrew/CSE110-Project.svg?branch=rails)](https://travis-ci.org/tangandrew/CSE110-Project) |

## Introduction

<b>Welcome to TURDMate!</b>

This is a web based application designed to help users manage their living spaces.

Our application assists you with the difficulties of living with roommates, from recording important documents such as the lease, notifying
roommates, and splitting expenses.

To start, just simply go to our hosted website, create an account and an apartment, and start filling up your aparment with roommates and all your necessary information!

Enjoy!

## The website link

<b>(The google form may say something different, make sure to use this one, we changed the port)</b>

http://34.208.173.107:443

## Login Credentials

| Username                | Password    | Description                                     |
|-------------------------|-------------|-------------------------------------------------|
| jsmith@example.com      | password123 | In apartment with lots of things inside         |
| noapartment@example.com | password123 | Not in an apartment                             |
| change@example.com      | password123 | In apartment with nothing                       |
| delete@example.com      | password123 | Account to be deleted, in an apartment          |
| turdmate@mailinator.com | password123 | Account for recovery, not in an apartment       |
| leave@example.com       | password123 | Account for leave apartment, is in an apartment |

## Download and install software
    Ruby 2.4.6: https://rubyinstaller.org/downloads/
    Yarn:       https://yarnpkg.com/en/docs/install

## Project Structure
    Folders and their purpose:
    
    app
    ├── controllers
    │   └── api
    │       └── v1          API
    └── javascript
        └── components
            ├── misc        Vue components
            └── pages       Vue pages
    config/                 misc. config files, see below
    db/                     contains database schema, database file
    lib/                    contains misc. code
    spec/acceptance         contains tests
    vendor/                 contains 3rd-party files/code
    
    Other important files:
    API routes              config/routes.rb
    API                     app/controllers/api/v1
    Config                  config/settings.yml
    Tests                   spec/acceptance
    Database schema         db/schema.rb
    Database fake data      db/seeds.rb
    Database                db/*.sqlite3
    Frontend API calls      app/javascript/api.js
    Vue global functions    app/javascript/mixin.js
    Vue global state        app/javascript/store.js
    Vue router              app/javascript/router.js

## Documentation/Tutorials
    Ruby                   (Language)    http://rubylearning.com/satishtalim/tutorial.html
    HTML/CSS/JS            (Language)    https://www.w3schools.com/
    
    Rails ActiveRecord     (SQL)         https://guides.rubyonrails.org/active_record_basics.html
    Rails ActionController (Api)         https://api.rubyonrails.org/classes/ActionController/API.html 
    Vue                    (JS)          https://vuejs.org/v2/guide/index.html
    Vue Router             (Routing)     https://router.vuejs.org/
    Vuex                   (State)       https://vuex.vuejs.org/
    Bootstrap+Vue          (CSS)         https://bootstrap-vue.js.org/
    
    RSpec                  
                           (Test)        https://semaphoreci.com/community/tutorials/getting-started-with-rspec
                           (API Test)    https://blog.eq8.eu/article/rspec-json-api-testing.html
                           (API Docs)    https://blog.codeship.com/producing-documentation-for-your-rails-api/
    
    Travis CI              (CI)
    
    Misc libraries:
    faker                  (Fake Data)   https://github.com/stympy/faker
    config                 (Config)      https://github.com/railsconfig/config
    
## Install packages
    # If bundler is not installed
    gem install bundler

    # Install new dependencies
    bundle install
    yarn install

## Set up database
    # Remove old database
    bundle exec rake db:drop:_unsafe

    # Populate database
    bundle exec rake db:schema:load db:seed
    
## Run server in developer mode (two separate consoles)
    # Start developer environment
    ruby .\bin\webpack-dev-server
    
    # Start server
    rails s
    
    # View webpage
    http://localhost:3000

## Run tests (located in /spec/acceptance)
    bundle exec rspec
    
## Generate API documentation
    bundle exec rails docs:generate
    
    # Start server (rails s)
    http://localhost:3000/api/docs
