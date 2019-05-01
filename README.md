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
