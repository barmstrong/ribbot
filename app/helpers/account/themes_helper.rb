module Account::ThemesHelper
  def theme_image theme, width=210
    height = (width.to_f * 0.8).round
    url = u("http://support.ribbot.com/?theme_preview=#{theme.id}")
    image_tag "http://api.thumbalizr.com/?url=#{url}&width=#{width}", :size => "#{width}x#{height}"
  end
end
