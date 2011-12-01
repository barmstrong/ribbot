module Account::ThemesHelper
  # these should go in an initializer but for some reason it can't read the variables when I do that
  Url2png::Config.public_key = 'P4ED717C89A831'
  Url2png::Config.shared_secret = 'SCFD8EF851C0B1'
  
  def theme_image theme, size="210x150"
    if Rails.env.production?
      url = "http://support.ribbot.com/?theme_preview=#{theme.id}"
      site_image_tag(url, :size => size).html_safe
    else
      image_tag "http://placehold.it/#{size}", :size => size
    end
  end
end
