class LessonsController < ApplicationController
  authorize_resource

  def index
    if params[:search]
      find_search_results
    elsif params[:deleted]
      find_deleted_lessons
    else
      flash.keep
      redirect_to courses_path
    end
  end

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      redirect_to lesson_path(@lesson), notice: 'Lesson saved.'
    else
      render 'new'
    end
  end

  def show
    @lesson = Lesson.with_deleted.find(params[:id])
    @section = Section.find(params[:section_id]) if params[:section_id]
    authorize! :read, @lesson
  end

  def edit
    @lesson = Lesson.with_deleted.find(params[:id])
  end

  def update
    @lesson = Lesson.with_deleted.find(params[:id])
    if params[:deleted]
      restore_lesson(@lesson)
    else
      if @lesson.update(lesson_params)
        redirect_to lesson_path(@lesson), notice: 'Lesson updated.'
      else
        render 'edit'
      end
    end
  end

  def destroy
    lesson = Lesson.find(params[:id])
    lesson_sections = LessonSection.where(lesson_id: lesson.id)
    lesson.destroy
    lesson_sections.each { |lesson_section| lesson_section.update(deleted_at: Time.zone.now) }
    redirect_to courses_path, notice: 'Lesson deleted.'
  end

private

  def lesson_params
    params.require(:lesson).permit(:name, :content, :cheat_sheet, :update_warning,
                                   :public, :deleted_at, :video_id, :tutorial, section_ids: [])
  end

  def restore_lesson(lesson)
    if lesson.restore
      lesson_sections = LessonSection.where(lesson_id: lesson.id)
      lesson_sections.each { |lesson_section| lesson_section.update(deleted_at: nil) }
      redirect_to courses_path, notice: 'Lesson restored.'
    else
      redirect_to :back, alert: 'Lesson not restored.'
    end
  end

  def find_search_results
    @query = params[:search]
    @results = Lesson.basic_search(@query)
    lesson_sections = LessonSection.where(lesson_id: @results.map(&:id))
    @sections = Section.where(id: lesson_sections.map(&:section_id))
    render :search_results
  end

  def find_deleted_lessons
    @lessons = Lesson.only_deleted
    lesson_sections = LessonSection.where(lesson_id: @lessons.map(&:id))
    sections = Section.where(id: lesson_sections.map(&:section_id))
    @courses = sections.map { |section| Course.find(section.course_id) }.uniq
    render :deleted
  end
end
