module FormHelper
  def lesson_form(&block)
    if params[:action] == 'edit' || params[:action] == 'update'
      form_for [@section, @lesson], &block
    elsif params[:action] == 'new' || params[:action] == 'create'
      form_for @lesson, &block
    end
  end
end
