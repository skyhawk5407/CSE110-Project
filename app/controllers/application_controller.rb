class ApplicationController < ActionController::Base
# Prevent CSRF attacks, except for JSON requests (API clients)
  protect_from_forgery unless: -> { request.format.json? }

# Require authentication and do not set a session cookie for JSON requests (API clients)
  before_action :do_not_set_cookie, if: -> { request.format.json? }

  private

# Do not generate a session or session ID cookie
# See https://github.com/rack/rack/blob/master/lib/rack/session/abstract/id.rb#L171
  def do_not_set_cookie
    request.session_options[:skip] = true
  end

  def authenticated?
    email = request.headers['EMAIL'].to_s
    password = request.headers['PASSWORD'].to_s
    user = User.find_by_email(email)
    if user.nil? or not user.authenticate(password)
      render :plain => 'Incorrect email or password',
             :status => :unauthorized
    end
  end

  def user_belongs_to_apartment?
    email = request.headers['EMAIL'].to_s
    user = User.find_by_email(email)
    # Check that user exists
    if user.nil?
      render :plain =>  'User not found',
             :status => :not_found
    end
    # Check that apartment matches
    unless user.apartment_id == params['apartment_id']
      render :plain => 'User does not belong to apartment',
             :status => :unauthorized
    end
  end
end
