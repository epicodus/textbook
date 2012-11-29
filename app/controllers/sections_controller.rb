class SectionsController < ApplicationController
  load_and_authorize_resource

  def index
    load_chapters
    respond_with @sections
  end

  def new
    load_chapters
    respond_with @section
  end

  def create
    load_chapters
    @section.save
    respond_with @section
  end

  def show
    load_chapters
    respond_with @section
  end

  def edit
    load_chapters
    respond_with @section
  end

  def update
    load_chapters
    @section.update_attributes(params[:section])
    respond_with @section
  end

  def destroy
    load_chapters
    @section.destroy
    respond_with @section
  end

  private

  def load_chapters
    @chapters = Chapter.all
  end
end
