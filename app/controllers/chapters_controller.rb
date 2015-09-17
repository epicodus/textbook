class ChaptersController < InheritedResources::Base
  load_and_authorize_resource

  def update_multiple
    Chapter.update(params[:chapters].keys, params[:chapters].values)
    flash[:notice] = "Order updated."
    respond_to do |f|
      f.html { redirect_to :back }
      f.js {}
    end
  end

private

  def permitted_params
    params.permit(:chapter => [:name, :number, :public, :sections_attributes => [:name, :number, :chapter_id, :public], :lessons_attributes => [:name, :content, :section_id, :number, :public, :deleted_at, :video_id]])
  end
end
