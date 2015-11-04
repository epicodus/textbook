class ChaptersController < InheritedResources::Base
  load_and_authorize_resource

  def index
    @chapters = Chapter.includes([:sections, :lessons])
  end

  def update
    if params[:commit] == 'Save order'
      update_section_and_lesson_order
      redirect_to table_of_contents_path, notice: "Order updated."
    else
      chapter = Chapter.find(params[:id])
      if chapter.update(chapter_params)
        redirect_to chapter_path(chapter), notice: "Chapter updated."
      else
        render 'edit'
      end
    end
  end

private

  def chapter_params
    params.require(:chapter).permit(:name, :number, :public,
                                    sections_attributes: [:name, :number, :chapter_id, :public],
                                    lessons_attributes: [:name, :content, :section_id, :number, :public, :deleted_at, :video_id])
  end

  def update_section_and_lesson_order
    sections = params[:chapter][:sections_attributes].map { |section| Section.find(section[1][:id]) }
    lessons = params[:chapter][:lessons_attributes].map { |lesson| Lesson.find(lesson[1][:id]) }
    lesson_sections = LessonSection.where(section_id: sections.map(&:id), lesson_id: lessons.map(&:id))
    params[:chapter][:lessons_attributes].each do |lesson|
      lesson_section = lesson_sections.find_by(lesson_id: lesson[1][:id])
      lesson_section.update(number: lesson[1][:number])
    end
  end
end
