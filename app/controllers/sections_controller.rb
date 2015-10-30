class SectionsController < InheritedResources::Base
  load_and_authorize_resource :except => [:index]

  helper_method :chapters

  def index
    flash.keep
    redirect_to table_of_contents_path
  end

  def show
    @section = Section.find(params[:id])
  end

private

  def section_params
    params.require(:section).permit(:name, :number, :chapter_id, :public)
  end

  def chapters
    Chapter.all
  end
end
