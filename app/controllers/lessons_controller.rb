class LessonsController < ApplicationController
  authorize_resource

  def index
    @chapters = Chapter.all
    render '/chapters/index'
  end

  def new
    load_sections
    respond_with @lesson = Lesson.new
  end

  def create
    load_sections
    respond_with @lesson = Lesson.create(params[:lesson])
  end

  def show
    load_sections
    respond_with @lesson = Lesson.find(params[:id])
  end

  def edit
    load_sections
    respond_with @lesson = Lesson.find(params[:id])
  end

  def update
    load_sections
    @lesson = Lesson.find(params[:id])
    @lesson.update_attributes(params[:lesson])
    respond_with @lesson
  end

  def destroy
    load_sections
    respond_with @lesson = Lesson.find(params[:id]).destroy
  end

  private

  def load_sections
    @sections = Section.all
  end
end
