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
    authorize! :read, @section
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.with_deleted.find(params[:id])
    if params[:deleted]
      @section.restore
      redirect_to course_path(@section.course), notice: "Section restored."
    elsif @section.update(section_params)
      redirect_to course_section_path(@section.course, @section), notice: "Section updated."
    else
      render 'edit'
    end
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    redirect_to course_path(@section.course), notice: 'Section deleted.'
  end

private

  def section_params
    params.require(:section).permit(:name, :course_id, :public, :week, :layout_file_path)
  end
end
