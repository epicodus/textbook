class HomeController < ApplicationController
  def show
    if Lesson.accessible_by(current_ability).any?
      first_course = Course.accessible_by(current_ability).first
      first_section = first_course.sections.accessible_by(current_ability).first
      first_lesson = first_section.lessons.accessible_by(current_ability).first
      redirect_to course_section_lesson_path(first_course, first_section, first_lesson)
    end
  end
end
