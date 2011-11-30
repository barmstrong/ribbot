module Account::ThemesHelper
  def theme_image theme, width=210
    height = (width.to_f * 0.8).round
    if Rails.env.production?
      url = "http://support.ribbot.com/?theme_preview=#{theme.id}"
      image_tag "http://api.thumbalizr.com/?url=#{url}&width=#{width}&api_key=b2b404b2204583aa14fb20c214003453", :size => "#{width}x#{height}"
    else
      image_tag "http://placehold.it/#{width}x#{height}", :size => "#{width}x#{height}"
    end
  end
end
