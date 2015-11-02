class LessonsController < InheritedResources::Base
  before_filter :find_deleted_lesson, :only => [:show, :edit, :update]

  load_and_authorize_resource

  helper_method :sections
  helper_method :chapters

  def index
    @section = Section.find(params[:section_id]) if params[:section_id]
    if params[:search]
      find_search_results
    elsif params[:deleted]
      find_deleted_lessons
    else
      flash.keep
      redirect_to table_of_contents_path
    end
  end

  def create
    section = Section.find(params[:lesson][:section_ids])
    lesson = Lesson.new(lesson_params)
    if lesson.save
      lesson_section = LessonSection.find_by(section_id: section.id, lesson_id: lesson.id)
      lesson_section.update(number: params[:lesson][:number])
      redirect_to lesson_show_path(section, lesson), notice: 'Lesson saved.'
    else
      redirect_to new_lesson_path, alert: 'Lesson not saved.'
    end
  end

  def show
    @section = Section.find(params[:section_id]) if params[:section_id]
  end

  def edit
    @section = Section.find(params[:section_id])
    @lesson_section = LessonSection.find_by(section_id: @section.id, lesson_id: @lesson.id)
  end

  def update
    lesson = Lesson.with_deleted.find(params[:id])
    if params[:deleted]
      restore_lesson(lesson)
    else
      if lesson.update(lesson_params)
        section = Section.find(params[:lesson][:section_ids])
        lesson_section = LessonSection.find_by(section_id: section.id, lesson_id: lesson.id)
        lesson_section.update(number: params[:lesson][:number])
        redirect_to lesson_show_path(section, lesson), notice: 'Lesson updated.'
      else
        redirect_to :back, alert: 'Lesson not updated.'
      end
    end
  end

  def destroy
    lesson = Lesson.find(params[:id])
    section = Section.find(params[:section_id])
    lesson_section = LessonSection.find_by(section_id: section.id, lesson_id: lesson.id)
    lesson.number = lesson_section.number
    if lesson.destroy
      lesson_section.update(deleted_at: Time.zone.now)
      redirect_to section_show_path(section), notice: 'Lesson deleted.'
    else
      redirect_to :back, alert: 'Lesson not deleted.'
    end
  end

private

  def lesson_params
    params.require(:lesson).permit(:name, :content, :cheat_sheet, :update_warning,
                                   :number, :public, :deleted_at, :video_id, :tutorial, :section_ids)
  end

  def restore_lesson(lesson)
    if lesson.restore
      lesson_sections = LessonSection.where(lesson_id: lesson.id)
      lesson_sections.each { |lesson_section| lesson_section.update(deleted_at: nil) }
      redirect_to table_of_contents_path, notice: 'Lesson restored.'
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
    @sections = Section.where(id: lesson_sections.map(&:section_id))
    render :deleted
  end

  def sections
    Section.all
  end

  def chapters
    Chapter.all
  end

  def find_deleted_lesson
    @lesson = Lesson.with_deleted.find(params[:id]) if params[:deleted]
  end
end
