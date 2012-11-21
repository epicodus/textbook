class HomeController < ApplicationController
  def show
    if Lesson.any?
      redirect_to Chapter.first.sections.first.lessons.first
    end
  end
end
