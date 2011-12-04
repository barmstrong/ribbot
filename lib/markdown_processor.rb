module MarkdownProcessor
  
  class CustomHTMLRenderer < Redcarpet::Render::HTML
    include ActionView::Helpers::UrlHelper
    
    def link(link, title, content)
      link_to content, link, :title => title, :rel => 'nofollow'
    end
    
    def autolink(link, link_type)
      link_to link, link, :rel => 'nofollow'
    end
  end
  
  MARKDOWN_RENDERER = CustomHTMLRenderer.new(:filter_html => true)
  MARKDOWN = Redcarpet::Markdown.new(MARKDOWN_RENDERER, :autolink => true, :safe_links_only => true)
  
  def process_markdown force = false, source = :text, destination = :html
    if force or send("#{source}_changed?")
      self.write_attribute(destination, MARKDOWN.render(self.read_attribute(source)))
    end
  end
  
end