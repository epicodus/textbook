class SectionsController < ApplicationController
  authorize_resource

  def index
    load_chapters
    render '/chapters/index'
  end

  def new
    load_chapters
    respond_with @section = Section.new
  end

  def create
    load_chapters
    respond_with @section = Section.create(params[:section])
  end

  def show
    load_chapters
    respond_with @section = Section.find(params[:id])
  end

  def edit
    load_chapters
    respond_with @section = Section.find(params[:id])
  end

  def update
    load_chapters
    @section = Section.find(params[:id])
    @section.update_attributes(params[:section])
    respond_with @section
  end

  def destroy
    load_chapters
    respond_with @section = Section.find(params[:id]).destroy
  end

  private

  def load_chapters
    @chapters = Chapter.all
  end
end
