class SectionsController < ApplicationController
  authorize_resource

  def index
    flash.keep
    redirect_to courses_path
  end

  def new
    @section = Section.new
    @section.course = Course.find(params[:course_id])
  end

  def create
    @section = Section.new(section_params)
    @section.course = Course.find(params[:course_id])
    if @section.save
      redirect_to course_path(@section.course), notice: 'Section saved.'
    else
      render 'new'
    end
  end

  def show
    @section = Section.find(params[:id])
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    if @section.update(section_params)
      redirect_to section_show_path(@section), notice: "Section updated."
    else
      render 'edit'
    end
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    respond_to do |format|
      format.js { render 'destroy' }
    end
  end

private

  def section_params
    params.require(:section).permit(:name, :course_id, :public, :week)
  end
end
