class PagesController < ApplicationController
  authorize_resource

  def index
    @chapters = Chapter.all
    render '/chapters/index'
  end

  def new
    @chapters = Chapter.all
    @sections = Section.all
    respond_with @page = Page.new
  end

  def create
    respond_with @page = Page.create(params[:page])
  end

  def show
    @chapters = Chapter.all
    @sections = Section.all
    respond_with @page = Page.find(params[:id])
  end

  def edit
    @chapters = Chapter.all
    @sections = Section.all
    respond_with @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    respond_with @page
  end

  def destroy
    respond_with @page = Page.find(params[:id]).destroy
  end
end
