module Account::ThemesHelper
  
  def theme_image theme, size="210x150"
    url = "http://support.ribbot.com/?theme_preview=#{theme.id}"
    site_image_tag(url, :size => size).html_safe
  end
end
