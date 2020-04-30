desc "regenerate all section & lesson slugs"
task :tmp_regenerate_slugs => [:environment] do
  Lesson.skip_callback(:validation, :before, :set_placeholder_content)
  Lesson.skip_callback(:save, :after, :update_from_github)
  Section.skip_callback(:update, :after, :build_section)

  Section.all.each do |section|
    section.slug = nil
    section.save(validation: false)
  end

  Lesson.all.each do |lesson|
    lesson.slug = nil
    lesson.save(validation: false)
  end

  Section.set_callback(:update, :after, :build_section)
  Lesson.set_callback(:save, :after, :update_from_github)
  Lesson.set_callback(:validation, :before, :set_placeholder_content)
end
