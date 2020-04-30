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

  def show
    begin
      @lesson = Lesson.find(params[:id])
      @section = Section.find(params[:section_id]) if params[:section_id]
      authorize! :read, @lesson
    rescue ActiveRecord::RecordNotFound
      render file: "#{Rails.root}/public/404", status: :not_found
    end
  end

private

  def find_search_results
    @query = params[:search]
    if current_user && current_user.author?
      @results = Lesson.basic_search(@query)
      @sections = Section.where(id: @results.map(&:section_id))
    else
      @results = Lesson.basic_search(@query).where(public: true)
      @sections = Section.where(id: @results.map(&:section_id)).where(public: true)
    end
    render :search_results
  end
end
