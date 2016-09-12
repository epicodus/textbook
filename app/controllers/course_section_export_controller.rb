class CourseSectionExportController < ApplicationController

  def show
    section = Section.find(params[:section_id])
    filename = section.export_lessons
    send_file(filename)    
  end

end