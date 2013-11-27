class SectionsController < InheritedResources::Base
  load_and_authorize_resource :except => [:index]

  helper_method :chapters

  def index
    flash.keep
    redirect_to table_of_contents_path
  end

  private

  def permitted_params
    params.permit(:section => [:name, :number, :chapter_id, :public])
  end

  def chapters
    Chapter.all
  end
end
