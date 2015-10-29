class ChaptersController < InheritedResources::Base
  load_and_authorize_resource

  def index
    @chapters = Chapter.includes([:sections, :lessons])
  end

  def update_multiple
    Chapter.update(params[:chapters].keys, params[:chapters].values)
    sections = params[:chapters].first[1][:sections_attributes].map { |section| Section.find(section[1][:id]) }
    lessons = params[:chapters].first[1][:lessons_attributes].map { |lesson| Lesson.find(lesson[1][:id]) }
    lesson_sections = LessonSection.where(section_id: sections.map(&:id), lesson_id: lessons.map(&:id))
    params[:chapters].first[1][:lessons_attributes].each do |lesson|
      lesson_section = lesson_sections.find_by(lesson_id: lesson[1][:id])
      lesson_section.update(number: lesson[1][:number])
    end
    redirect_to table_of_contents_path
    flash[:notice] = "Order updated."
  end

private

  def permitted_params
    params.permit(:chapter => [:name, :number, :public, :sections_attributes => [:name, :number, :chapter_id, :public], :lessons_attributes => [:name, :content, :section_id, :number, :public, :deleted_at, :video_id]])
  end
end
