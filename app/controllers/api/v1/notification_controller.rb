# frozen_string_literal: true

# localhost:3000/api/v1/apartments/notifications
class Api::V1::NotificationController < ApplicationController
  before_action :authenticated?
  before_action :get_apartment
  before_action :get_notifications, only: [:mark_read]

  def create
    # Create notification
    notification = Notification.create(
        :apartment_id => @apartment.id,
        :user_id => params[:anonymous] ? nil : @user.id ,
        :title => params[:title],
        :message => params[:message]
    )
    return render :json => {:errors => notification.errors.full_messages}, status: :bad_request unless notification.valid?
    return render plain: 'Anonymous notification sent!', status: :ok if params[:anonymous]
    render plain: 'Notification sent!', status: :ok
  end

  def get_all
    timerange = params[:timestamp].nil? ? nil : DateTime.parse(params[:timestamp])..DateTime::Infinity.new
    query = {:apartment_id => @apartment.id,
             :created_at => timerange}.reject{|_,v| v.nil?}
    notifications = Notification.where(query).includes(:user)
    unread_notifications = UnreadNotification.where(:user_id => @user.id)
                                             .map{|x| x.notification_id}
                                             .to_set

    render :json => notifications.map{|x| x.attributes.merge({:read => !unread_notifications.include?(x.id), :creator_name => x.user.nil? ? 'Anonymous' : x.user.display_name})}, status: :ok
  end

  def mark_read
    UnreadNotification.where(:notification_id => @notifications.map{|x| x.id}, :user_id => @user.id).destroy_all
    render plain: 'Notifications marked as read', status: :ok
  end

  private
  def get_notifications
    @notifications = Notification.where(:id =>params[:notification_ids])
    render :json => {:errors => ['No notifications specified']}, status: :bad_request if @notifications.length == 0
    @notifications.each do |x|
      return render :json => {:errors => ['Unauthorized notification ID(s)']}, status: :unauthorized unless @apartment.id == x.apartment_id
    end
  end
end
