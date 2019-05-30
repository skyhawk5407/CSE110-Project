class NotificationMailer < ApplicationMailer
  def new_notification
    notification = params[:notification]
    recipient = params[:user]

    sender = notification.user_id.nil? ? nil : User.find(notification.user_id)
    @sender_name = sender.nil? ? 'One of your apartmentmates': sender.display_name
    @display_name = recipient.display_name
    @title = notification.title
    @message_sample = notification.message
    @apartment_name = Apartment.find(notification.apartment_id).name

    mail(to: recipient.email, subject: "Apartment Notification - #{@title}")
  end
end