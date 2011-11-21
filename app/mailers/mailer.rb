class Mailer < ActionMailer::Base
  default from: "no-reply@ribbot.com"

  def password_reset user
    @user = user
    mail :to => user.email, :subject => "Resetting Your Password"
  end
  
  def email_verification user, forum=nil
    @user = user
    mail :to => user.email, :subject => "Please Verify Your Email Address"
  end
end
