class ChaptersController < InheritedResources::Base
  load_and_authorize_resource

  def update_multiple
    Chapter.update(params[:chapters].keys, params[:chapters].values)
    redirect_to table_of_contents_path
    flash[:notice] = "Order updated."
  end

  private

  def permitted_params
    params.permit(:chapter => [:name, :number, :public, :sections_attributes => [:name, :number, :chapter_id, :public], :lessons_attributes => [:name, :content, :section_id, :number, :public, :deleted_at, :video_id]])
  end
end
