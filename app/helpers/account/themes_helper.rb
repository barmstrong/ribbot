module Account::ThemesHelper
  def theme_image theme
    #image_tag "http://img.bitpixels.com/getthumbnail?code=41212&size=200&url=http://test.ribbot.com?theme_preview=#{theme.id}", :size => "200x200"
    #image_tag "http://images.sitethumbshot.com/?size=M&key=eb53bd1ae51f7a986ab450e67979cf27&url=http://test.ribbot.com?theme_preview=#{theme.id}", :size => "200x150"
    url = u("http://support.ribbot.com/?theme_preview=#{theme.id}")
    image_tag "http://api.thumbalizr.com/?url=#{url}&width=210"
  end
end
