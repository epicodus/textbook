class RemoveTutorialFromLessonsAndMigrateToLessonSections < ActiveRecord::Migration
  def up
    LessonSection.where(lesson: Lesson.where(tutorial: false)).update_all(work_type: 1)

    rename_column :lessons, :tutorial, :old_tutorial
  end

  def down
    LessonSection.update_all(work_type: 0)

    rename_column :lessons, :old_tutorial, :tutorial
  end
end
