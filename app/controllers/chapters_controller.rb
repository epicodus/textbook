class ChaptersController < InheritedResources::Base
  load_and_authorize_resource

  def update_multiple
    Chapter.update(params[:chapters].keys, params[:chapters].values)
    redirect_to table_of_contents_path
    flash[:notice] = "Order updated."
  end
end
