class SectionsController < InheritedResources::Base
  load_and_authorize_resource

  before_filter :load_chapters
end
