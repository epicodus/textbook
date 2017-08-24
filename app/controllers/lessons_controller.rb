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
      section = Section.find(params.dig(:lesson, :section_ids)[1])
      redirect_to lesson_path(@lesson), notice: 'Lesson saved.'
    else
      render 'new'
    end
  end

  def show
    @lesson = Lesson.with_deleted.find(params[:id])
    @section = Section.find(params[:section_id]) if params[:section_id]
    @lesson_section = LessonSection.find_by(lesson: @lesson, section: @section)
    authorize! :read, @lesson
  end

  def edit
    @lesson = Lesson.with_deleted.find(params[:id])
  end

  def update
    @lesson = Lesson.with_deleted.find(params[:id])
    if params[:deleted] && params[:section_id]
      @lesson.restore
      lesson_section = LessonSection.only_deleted.find_by(lesson: @lesson, section_id: params[:section_id])
      lesson_section.restore
      redirect_to course_section_path(lesson_section.section.course, lesson_section.section), notice: "Lesson restored to this section. (Lesson is private.)"
    elsif params[:deleted]
      @lesson.restore
      lesson_sections = LessonSection.only_deleted.where(lesson_id: @lesson.id)
      lesson_sections.each { |lesson_section| lesson_section.restore }
      redirect_to lesson_path(@lesson), notice: 'Lesson restored to all its sections. (Lesson is private.)'
    else
      lesson_section_ids = lesson_params[:lesson_sections_attributes].map { |param| param[1][:id] }
      lesson_sections_to_delete = LessonSection.where(lesson: @lesson) - LessonSection.find(lesson_section_ids)
      lesson_sections_to_delete.each(&:destroy)
      if @lesson.update(lesson_params)
        redirect_to lesson_path(@lesson), notice: 'Lesson updated.'
      else
        render 'edit'
      end
    end
  end

  def destroy
    lesson = Lesson.find(params[:id])
    if params[:section_id]
      section = Section.find(params[:section_id])
      LessonSection.find_by(lesson: lesson, section: section).destroy
      redirect_to course_section_path(section.course, section), notice: 'Lesson removed from this section.'
    else
      lesson.destroy
      redirect_to courses_path, notice: 'Lesson deleted.'
    end
  end

private

  def lesson_params
    params[:lesson][:lesson_sections_attributes].keep_if { |key, value| value[:work_type] }
    params.require(:lesson).permit(:name, :content, :cheat_sheet, :update_warning, :teacher_notes,
                                   :public, :deleted_at, :video_id,
                                   lesson_sections_attributes: [:id, :work_type, :section_id, :day_of_week])
  end

  def find_search_results
    @query = params[:search]
    if current_user && current_user.author?
      @results = Lesson.basic_search(@query)
      lesson_sections = LessonSection.where(lesson_id: @results.map(&:id))
      @sections = Section.where(id: lesson_sections.map(&:section_id))
    else
      @results = Lesson.basic_search(@query).where(public: true)
      lesson_sections = LessonSection.where(lesson_id: @results.map(&:id))
      @sections = Section.where(id: lesson_sections.map(&:section_id)).where(public: true)
    end
    render :search_results
  end

  def find_deleted_lessons
    @lessons = Lesson.only_deleted
    lesson_sections = LessonSection.only_deleted.where(lesson_id: @lessons.map(&:id))
    sections = Section.where(id: lesson_sections.map(&:section_id))
    @courses = sections.map { |section| Course.find(section.course_id) }.uniq
    render :deleted
  end
end
