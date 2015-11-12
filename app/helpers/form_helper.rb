module FormHelper
  def lesson_form(&block)
    if params[:action] == 'edit' || params[:action] == 'update'
      form_for [@section, @lesson], &block
    elsif params[:action] == 'new' || params[:action] == 'create'
      form_for @lesson, &block
    end
  end

  def section_form(&block)
    if params[:action] == 'edit' || params[:action] == 'update'
      form_for @section, url: course_section_path(@section.course, @section), &block
    elsif params[:action] == 'new' || params[:action] == 'create'
      form_for @section, url: course_sections_path(@section.course), &block
    end
  end
end
