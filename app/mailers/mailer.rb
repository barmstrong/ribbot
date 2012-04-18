class Mailer < ActionMailer::Base
  default from: "Ribbot.com <contact@ribbot.com>"

  def password_reset user
    @user = user
    @host = user.host_for_email
    mail :to => user.email, :subject => "Resetting Your Password"
  end
  
  def email_verification user, forum
    @user = user
    @host = user.host_for_email
    mail :to => user.email, :subject => "Please Verify Your Email Address"
  end
  
end
