module FormHelper
  def form_for_object(object_type, &block)
    if params[:action] == 'edit'
      form_for object_type, &block
    elsif params[:action] == 'new'
      form_for object_type, remote: true, &block
    end
  end
end
