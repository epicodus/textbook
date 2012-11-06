class SectionsController < ApplicationController
  authorize_resource

  def index
    respond_with @sections = Section.all
  end

  def new
    respond_with @section = Section.new
  end

  def create
    respond_with @section = Section.create(params[:section])
  end

  def show
    respond_with @section = Section.find(params[:id])
  end

  def edit
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
