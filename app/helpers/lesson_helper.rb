module LessonHelper
  def markdown(text)
    html = Redcarpet::Render::HTML.new(:prettify => true, :with_toc_data => true)
    markdown = Redcarpet::Markdown.new(html, :space_after_headers => true, :fenced_code_blocks => true, :tables => true)
    markdown.render(text).html_safe
  end
end
