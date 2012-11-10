module Account::ThemesHelper
  
  def theme_image theme, size="210x150"
    if Rails.env.production?
      url = "support.ribbot.com/?theme_preview=#{theme.id}"
      site_image_tag(webyshots_url(url, size), :size => size).html_safe
    else
      image_tag "http://placehold.it/#{size}"
    end
  end

  def webyshots_url(url, size)
    safe_url = CGI.escape(url)
    token = Digest::MD5.hexdigest("#{ENV['WEBYSHOTS_SECRET']}+#{safe_url}")
    "http://api.webyshots.com/v1/shot/#{ENV['WEBYSHOT_KEY']}/#{token}/#{safe_url}/png/#{size}"
  end
end
