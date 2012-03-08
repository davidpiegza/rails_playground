class NotifyMailer < ActionMailer::Base

  def notify
    mail subject: "New message", to: ENV['EMAIL_ADDRESS'], from: 'app3181067@heroku.com'
  end

end
