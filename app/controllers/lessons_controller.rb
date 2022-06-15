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
      if params[:section_id]
        course = Course.find(params[:course_id])
        @section = course.sections.find(params[:section_id])
        @lesson = @section.lessons.find(params[:id])
        authorize! :read, @lesson
        render :show
      else
        @lessons = Lesson.active_lessons.where(slug: params[:id])
        render :lesson_chooser
      end
    rescue ActiveRecord::RecordNotFound
      render file: Rails.root.join('public/404.html'), status: :not_found
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
