module LessonHelper
  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            :autolink => true,
                            :space_after_headers => true,
                            :fenced_code_blocks => true,
                            :prettify => true)
    .render(text).html_safe
  end
end
