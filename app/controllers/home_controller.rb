class HomeController < ApplicationController
  def show
    if Lesson.accessible_by(current_ability).any?
      first_section = Course.accessible_by(current_ability).first.sections.accessible_by(current_ability).first
      redirect_to section_lesson_show_path(first_section, first_section.lessons.accessible_by(current_ability).first)
    end
  end
end
