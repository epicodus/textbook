class LessonsController < ApplicationController
  load_and_authorize_resource

  def index
    @chapters = Chapter.all
    respond_with @lessons
  end

  def new
    load_sections
    respond_with @lesson
  end

  def create
    load_sections
    @lesson.save
    respond_with @lesson
  end

  def show
    load_sections
    respond_with @lesson
  end

  def edit
    load_sections
    respond_with @lesson
  end

  def update
    load_sections
    @lesson.update_attributes(params[:lesson])
    respond_with @lesson
  end

  def destroy
    load_sections
    respond_with @lesson.destroy
  end

  private

  def load_sections
    @sections = Section.all
  end
end
