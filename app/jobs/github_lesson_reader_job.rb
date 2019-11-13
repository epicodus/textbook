class GithubLessonReaderJob < ApplicationJob
  queue_as :default

  def perform(lesson)
    Lesson.update_from_github(lesson)
  end
end
