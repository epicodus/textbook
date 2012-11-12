class SectionsController < ApplicationController
  authorize_resource

  def index
    @chapters = Chapter.all
    render '/chapters/index'
  end

  def new
    @chapters = Chapter.all
    respond_with @section = Section.new
  end

  def create
    respond_with @section = Section.create(params[:section])
  end

  def show
    @chapters = Chapter.all
    respond_with @section = Section.find(params[:id])
  end

  def edit
    @chapters = Chapter.all
    respond_with @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    @section.update_attributes(params[:section])
    respond_with @section
  end

  def destroy
    respond_with @section = Section.find(params[:id]).destroy
  end
end
