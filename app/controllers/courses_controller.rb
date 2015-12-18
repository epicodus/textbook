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
    lesson_sections = LessonSection.where(lesson_id: @course.lessons.map(&:id), section_id: @course.sections.map(&:id))
    params[:course][:lessons_attributes].each do |lesson|
      lesson_sections.find_by(lesson_id: lesson[1][:id]).update(number: lesson[1][:number])
    end
  end
end
