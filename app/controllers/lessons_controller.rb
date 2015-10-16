class LessonsController < InheritedResources::Base
  before_filter :find_deleted_lesson, :only => [:show, :edit, :update]

  load_and_authorize_resource

  helper_method :sections
  helper_method :chapters

  def index
    @section = Section.find(params[:section_id])
    if params[:search]
      @query = params[:search]
      @results = Lesson.basic_search(@query)
      render :search_results
    elsif params[:deleted]
      @lessons = @section.lessons.only_deleted
      render :deleted
    else
      flash.keep
      redirect_to table_of_contents_path
    end
  end

  def show
    @section = Section.find(params[:section_id])
  end

private

  def permitted_params
    params.permit(:lesson => [:name, :content, :cheat_sheet, :update_warning, :section_id,
                              :number, :public, :deleted_at, :video_id, :tutorial])
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
