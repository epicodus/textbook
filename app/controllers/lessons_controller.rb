class LessonsController < ApplicationController
  authorize_resource

  def index
    if params[:search]
      find_search_results
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
    begin
      @lesson = Lesson.find(params[:id])
      @section = Section.find(params[:section_id]) if params[:section_id]
      @lesson_section = LessonSection.find_by(lesson: @lesson, section: @section)
      authorize! :read, @lesson
    rescue ActiveRecord::RecordNotFound
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

  def edit
    @lesson = Lesson.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    lesson_section_ids = lesson_params.to_h[:lesson_sections_attributes].map { |param| param[1][:id] }
    lesson_sections_to_delete = LessonSection.where(lesson: @lesson) - LessonSection.find(lesson_section_ids)
    lesson_sections_to_delete.each(&:destroy)
    if @lesson.update(lesson_params)
      redirect_to lesson_path(@lesson), notice: 'Lesson updated.'
    else
      render 'edit'
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
                                   :public, :deleted_at, :video_id, :github_path,
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
end
