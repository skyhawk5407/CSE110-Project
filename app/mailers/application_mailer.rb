class ApplicationMailer < ActionMailer::Base
  default from: "#{Settings.EMAIL.USERNAME}@#{Settings.EMAIL.DOMAIN}"
  layout 'mailer'
end
