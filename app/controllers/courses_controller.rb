class CoursesController < ApplicationController
  load_and_authorize_resource

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to courses_path, notice: 'Course saved.'
    else
      render 'new'
    end
  end

  def update
    if params[:commit] == 'Save order'
      update_section_and_lesson_order
      redirect_to courses_path, notice: "Order updated."
    else
      @course = Course.find(params[:id])
      if @course.update(course_params)
        redirect_to course_path(@course), notice: "Course updated."
      else
        render 'edit'
      end
    end
  end

  def destroy
    course = Course.find(params[:id])
    course.destroy
    redirect_to courses_path, notice: 'Course deleted.'
  end

private

  def course_params
    params.require(:course).permit(:name, :number, :public,
                                    sections_attributes: [:name, :number, :course_id, :public],
                                    lessons_attributes: [:name, :content, :section_id, :number, :public, :deleted_at, :video_id])
  end

  def update_section_and_lesson_order
    sections = params[:course][:sections_attributes].map { |section| Section.find(section[1][:id]) }
    lessons = params[:course][:lessons_attributes].map { |lesson| Lesson.find(lesson[1][:id]) }
    lesson_sections = LessonSection.where(section_id: sections.map(&:id), lesson_id: lessons.map(&:id))
    params[:course][:lessons_attributes].each do |lesson|
      lesson_section = lesson_sections.find_by(lesson_id: lesson[1][:id])
      lesson_section.update(number: lesson[1][:number])
    end
    params[:course][:sections_attributes].each do |section|
      Section.find(section[1][:id]).update(number: section[1][:number])
    end
  end
end
