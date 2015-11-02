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

  def update
    section = Section.find(params[:id])
    if section.update(section_params)
      redirect_to section_show_path(section), notice: "Section updated."
    else
      redirect_to :back, alert: "Section not updated."
    end
  end

private

  def section_params
    params.require(:section).permit(:name, :number, :chapter_id, :public)
  end

  def chapters
    Chapter.all
  end
end
