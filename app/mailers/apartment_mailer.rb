class ApartmentMailer < ApplicationMailer
  def invite
    email = params[:email]

    @referrer_name = params[:user].display_name
    @token = params[:apartment].access_code
    @apartment_name = params[:apartment].name
    @address = params[:apartment].address

    @url = Settings.BASE_URL
    mail(to: email, subject: 'TURDMate Apartment Invitation')
  end
end
