module FormHelper
  def ajax_form_for(object_type, &block)
    if params[:action] == 'edit'
      form_for object_type, &block
    elsif params[:action] == 'new'
      form_for object_type, remote: true, &block
    end
  end

  def lesson_form(&block)
    if params[:action] == 'edit'
      form_for [@section, @lesson], &block
    elsif params[:action] == 'new'
      form_for @lesson, &block
    end
  end
end
