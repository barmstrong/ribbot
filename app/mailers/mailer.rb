class Mailer < ActionMailer::Base

  def password_reset user, forum
    @user = user
    customize(forum)
    mail :from => @from, :to => user.email, :subject => "Resetting Your Password"
  end
  
  def email_verification user, forum
    @user = user
    customize(forum)
    mail :from => @from, :to => user.email, :subject => "Please Verify Your Email Address"
  end
  
  private
  
  def customize forum
    if forum.nil?
      @host = Ribbot::Application.config.action_mailer.default_url_options[:host]
      @from = "Ribbot.com <contact@ribbot.com>"
    else
      @host = forum.hostname
      @from = "#{forum.name} <contact@ribbot.com>"
    end
  end
  
end
