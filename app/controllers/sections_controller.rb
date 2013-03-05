class SectionsController < InheritedResources::Base
  load_and_authorize_resource :except => [:index]

  helper_method :chapters

  private

  def chapters
    Chapter.all
  end
end
