class PagesController < ApplicationController
  authorize_resource

  def index
    @chapters = Chapter.all
    render '/chapters/index'
  end

  def new
    load_sections
    respond_with @page = Page.new
  end

  def create
    load_sections
    respond_with @page = Page.create(params[:page])
  end

  def show
    load_sections
    respond_with @page = Page.find(params[:id])
  end

  def edit
    load_sections
    respond_with @page = Page.find(params[:id])
  end

  def update
    load_sections
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    respond_with @page
  end

  def destroy
    load_sections
    respond_with @page = Page.find(params[:id]).destroy
  end

  private

  def load_sections
    @sections = Section.all
  end
end
