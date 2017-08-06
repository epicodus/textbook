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
    @course = Course.with_deleted.find(params[:id])
    if params[:deleted]
      @course.restore
      redirect_to course_path(@course), notice: "Course restored."
    elsif params[:commit] == 'Save Order'
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

  def update_multiple
    Course.update(params[:course_attributes].keys, params[:course_attributes].values)
    redirect_to courses_path, notice: "Order Updated"
  end

  def destroy
    course = Course.find(params[:id])
    course.destroy
    redirect_to courses_path, notice: 'Course deleted.'
  end

private

  def course_params
    params.require(:course).permit(:name, :public, course_attributes: [:number],
                                    sections_attributes: [:name, :number, :course_id, :public],
                                    lessons_attributes: [:name, :content, :section_id, :public, :deleted_at, :video_id])
  end

  def update_section_order
    sections_params = params[:course][:sections_attributes]
    @course.sections.update(sections_params.keys, sections_params.values)
  end

  def update_lesson_order
    params[:course][:lesson_sections_attributes].each do |lesson_section_params|
      lesson_section = LessonSection.find(lesson_section_params[1][:id])
      lesson_section.update(number: lesson_section_params[1][:number])
    end
  end
end
