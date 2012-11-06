class PagesController < ApplicationController
  authorize_resource
  before_filter :load_sections

  def index
    render '/sections/index'
  end

  def new
    respond_with @page = Page.new
  end

  def create
    respond_with @page = Page.create(params[:page])
  end

  def show
    respond_with @page = Page.find(params[:id])
  end

  def edit
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

  private

  def load_sections
    @sections = Section.all
  end
end
