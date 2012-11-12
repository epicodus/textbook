class ChaptersController < ApplicationController
  authorize_resource

  def index
    respond_with @chapters = Chapter.all
  end

  def new
    respond_with @chapter = Chapter.new
  end

  def create
    respond_with @chapter = Chapter.create(params[:chapter])
  end

  def show
    respond_with @chapter = Chapter.find(params[:id])
  end

  def edit
    respond_with @chapter = Chapter.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])
    @chapter.update_attributes(params[:chapter])
    respond_with @chapter
  end

  def destroy
    respond_with @chapter = Chapter.find(params[:id]).destroy
  end
end
