module FormHelper
  def course_and_section_form(object_type, &block)
    if params[:action] == 'edit' || params[:action] == 'update'
      form_for object_type, &block
    elsif params[:action] == 'new' || params[:action] == 'create'
      form_for object_type, remote: true, &block
    end
  end

  def lesson_form(&block)
    if params[:action] == 'edit' || params[:action] == 'update'
      form_for [@section, @lesson], &block
    elsif params[:action] == 'new' || params[:action] == 'create'
      form_for @lesson, &block
    end
  end
end
