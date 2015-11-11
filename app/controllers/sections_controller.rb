class SectionsController < InheritedResources::Base
  load_and_authorize_resource :except => [:index]

  helper_method :courses

  def index
    flash.keep
    redirect_to courses_path
  end

  def new
    @course = Course.find(params[:course_id])
  end

  def create
    course = Course.find(params[:course_id])
    section = Section.new(section_params)
    if section.save
      redirect_to course_path(course), notice: 'Section saved.'
    else
      @course = Course.find(params[:course_id])
      render 'new'
    end
  end

  def show
    @section = Section.find(params[:id])
  end

  def edit
    @course = Course.find(params[:course_id])
  end

  def update
    section = Section.find(params[:id])
    if section.update(section_params)
      redirect_to section_show_path(section), notice: "Section updated."
    else
      @course = Course.find(params[:course_id])
      render 'edit'
    end
  end

private

  def section_params
    params.require(:section).permit(:name, :course_id, :public, :week)
  end

  def courses
    Course.all
  end
end
