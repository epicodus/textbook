module LessonHelper
  def markdown(text)
    html = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(html, :autolink => true, :space_after_headers => true,
                                             :fenced_code_blocks => true)
    markdown.render(text).html_safe
  end
end
