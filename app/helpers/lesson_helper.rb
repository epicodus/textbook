module LessonHelper
  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                            :autolink => true,
                            :space_after_headers => true,
                            :prettify => true)
    .render(text).html_safe
  end
end
