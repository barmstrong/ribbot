module Account::ThemesHelper
  
  def theme_image theme, size="210x150"
    if Rails.env.production?
      url = "http://support.ribbot.com/?theme_preview=#{theme.id}"
      image_tag(webyshots_url(url, size), :size => size)
    else
      image_tag "http://placehold.it/#{size}"
    end
  end

  def webyshots_url(url, size)
    safe_url = CGI.escape(url)
    token = Digest::MD5.hexdigest("#{ENV['WEBYSHOTS_SECRET']}+#{safe_url}")
    "http://api.webyshots.com/v1/shot/#{ENV['WEBYSHOTS_KEY']}/#{token}/?url=#{safe_url}&dimension=#{size}&format=png".html_safe
  end
end
