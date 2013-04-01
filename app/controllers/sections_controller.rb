class SectionsController < InheritedResources::Base
  load_and_authorize_resource :except => [:index]

  helper_method :chapters

  def index
    flash.keep
    redirect_to table_of_contents_path
  end

  private

  def chapters
    Chapter.all
  end
end
