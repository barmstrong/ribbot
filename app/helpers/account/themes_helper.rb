module Account::ThemesHelper
  Url2png::Config.public_key = 'P4ED717C89A831'
  Url2png::Config.shared_secret = 'SCFD8EF851C0B1'
  
  def theme_image theme, size="210x150"
    if true or Rails.env.production?
      url = "http://support.ribbot.com/?theme_preview=#{theme.id}"
      site_image_tag(url, :size => size).html_safe
    else
      image_tag "http://placehold.it/#{size}", :size => size
    end
  end
end
