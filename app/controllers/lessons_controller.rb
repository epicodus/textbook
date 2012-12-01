class LessonsController < InheritedResources::Base
  load_and_authorize_resource

  helper_method :sections
  helper_method :chapters

  private

  def sections
    Section.all
  end

  def chapters
    Chapter.all
  end
end
