class CoursesController < ApplicationController
  authorize_resource

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to courses_path, notice: 'Course saved.'
    else
      render 'new'
    end
  end

  def show
    @course = Course.find(params[:id])
    authorize! :read, @course
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if params[:commit] == 'Save Order'
      update_section_order
      update_lesson_order
      redirect_to course_path(@course), notice: "Order updated."
    else
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

  def update_section_order
    sections_params = params[:course][:sections_attributes]
    @course.sections.update(sections_params.keys, sections_params.values)
  end

  def update_lesson_order
    sections = params[:course][:sections_attributes].map { |section| Section.find(section[1][:id]) }
    lessons = params[:course][:lessons_attributes].map { |lesson| Lesson.find(lesson[1][:id]) }
    lesson_sections = LessonSection.where(section_id: sections.map(&:id), lesson_id: lessons.map(&:id))
    params[:course][:lessons_attributes].each do |lesson|
      lesson_section = lesson_sections.find_by(lesson_id: lesson[1][:id])
      lesson_section.update(number: lesson[1][:number])
    end
  end
end
