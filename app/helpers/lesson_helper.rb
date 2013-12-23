module LessonHelper
  def markdown(text)
    html = Redcarpet::Render::HTML.new(:prettify => true)
    markdown = Redcarpet::Markdown.new(html, :autolink => true, :space_after_headers => true,
                                             :fenced_code_blocks => true, :prettify => true)
    markdown.render(text).html_safe
  end
end
