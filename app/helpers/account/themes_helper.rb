module Account::ThemesHelper
  def theme_image theme
    image_tag "http://img.bitpixels.com/getthumbnail?code=41212&size=200&url=http://test.ribbot.com?theme_preview=#{theme.id}", :size => "200x200"
  end
end
