class TracksController < ApplicationController
  authorize_resource

  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
    authorize! :read, @track
    if @track.courses.count == 1
      redirect_to course_path(@track.courses.first)
    else
      render :show
    end
  end
end
