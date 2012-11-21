class HomeController < ApplicationController
  def show
    if Lesson.any?
      @lesson = Chapter.first.sections.first.lessons.first
      render '/lessons/show'
    end
  end
end
