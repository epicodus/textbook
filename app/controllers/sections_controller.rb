class SectionsController < InheritedResources::Base
  load_and_authorize_resource :except => [:index]

  helper_method :courses

  def index
    flash.keep
    redirect_to courses_path
  end

  def show
    @section = Section.find(params[:id])
  end

  def update
    section = Section.find(params[:id])
    if section.update(section_params)
      redirect_to section_show_path(section), notice: "Section updated."
    else
      render 'edit'
    end
  end

private

  def section_params
    params.require(:section).permit(:name, :number, :course_id, :public, :week)
  end

  def courses
    Course.all
  end
end
