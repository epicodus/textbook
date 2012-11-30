class LessonsController < InheritedResources::Base
  load_and_authorize_resource

  before_filter :load_sections
  before_filter :load_chapters, :only => 'index'
end
