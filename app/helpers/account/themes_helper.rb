module Account::ThemesHelper
  
  def theme_image theme, size="210x150"
    if Rails.env.production?
      url = "http://support.ribbot.com/?theme_preview=#{theme.id}"
      site_image_tag(url, :size => size).html_safe
    else
      "http://placehold.it/#{size}"
    end
  end
end
