module ApplicationHelper
  def root_active?
    controller_name == "users" and action_name == "new"
  end
  
  def signin_active?
    controller_name == "sessions" and action_name == "new"
  end
  
  def flash_type_to_css_class type
    case type
    when :notice then 'warning'
    when :alert then 'error'
    end
  end
  
  def site_name
    current_forum.present? ? current_forum.name : "Ribbot"
  end
  
  def title
    return @title if @title.present?
    return @post.title if @post.present?
    site_name
  end
  
  def meta_description
    return @meta_description if @meta_description.present?
    return @post.text if @post.present?
    ""
  end
  
  def comment_offset depth
    depth = 8 if depth > 8
    "comment-offset#{depth}"
  end
  
  def current_namespace
    controller.class.name.split("::").first
  end
  
end
