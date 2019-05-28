class UserMailer < ApplicationMailer
  def reset_password
    @user = params[:user]

    query = {
      :email => @user.email,
      :reset_token => @user.reset_token
    }
    @url = "#{Settings.BASE_URL + Settings.RESET_TOKEN_PATH}?#{query.to_query}"
    mail(to: @user.email, subject: 'TURDMate Reset Password Confirmation')
  end
end
