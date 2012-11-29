class ChaptersController < ApplicationController
  load_and_authorize_resource

  def index
    respond_with @chapters
  end

  def new
    respond_with @chapter
  end

  def create
    @chapter.save
    respond_with @chapter
  end

  def show
    respond_with @chapter
  end

  def edit
    respond_with @chapter
  end

  def update
    @chapter.update_attributes(params[:chapter])
    respond_with @chapter
  end

  def destroy
    @chapter.destroy
    respond_with @chapter
  end
end
