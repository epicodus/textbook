describe Github, vcr: true do
  it 'updates lesson content based on Github repo name & list of file paths' do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_lessons({ repo: 'testing', modified: ['README.md'], removed: [] })
    expect(lesson.reload.content).to include 'testing'
  end

  it 'marks lesson as private when removed from Github repo' do
    lesson = FactoryBot.create(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    Github.update_lessons({ repo: 'testing', modified: [], removed: ['README.md'] })
    expect(lesson.reload.public).to be false
  end

  it 'fetches lesson content from Github given github_path' do
    github_path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md"
    expect(Github.get_content(github_path)[:content]).to include 'testing'
  end

  it 'builds lesson (work_type lesson) and lesson_section from Github' do
    lesson_section = Github.build_lesson(title: 'test lesson', day_of_week: 'monday', content_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/test_week/1d_Hash_Class.md")
    lesson = lesson_section.lesson
    expect(lesson_section.day_of_week).to eq 'monday'
    expect(lesson_section.work_type).to eq 'lesson'
    expect(lesson.name).to eq 'test lesson'
    expect(lesson.content.present?).to eq true
    expect(lesson.cheat_sheet.present?).to eq true
    expect(lesson.teacher_notes.present?).to eq false
  end

  it 'builds lesson (work_type exercise) and lesson_section from Github' do
    lesson_section = Github.build_lesson(title: 'test classwork', day_of_week: 'tuesday', content_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/test_week/2a_classwork_Scrabble_Score_Numbers_to_Words.md")
    lesson = lesson_section.lesson
    expect(lesson_section.day_of_week).to eq 'tuesday'
    expect(lesson_section.work_type).to eq 'exercise'
    expect(lesson.name).to eq 'test classwork'
    expect(lesson.content.present?).to eq true
    expect(lesson.cheat_sheet.present?).to eq false
    expect(lesson.teacher_notes.present?).to eq false
  end

  it 'builds section from layout file' do
    section = FactoryBot.create(:section, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/test_week")
    expect(section.lessons.any?).to eq true
    expect(section.lesson_sections.any?).to eq true
    expect(section.lessons.find_by(name: 'Hash Class').present?).to eq true
    expect(section.lessons.find_by(name: 'Hash Class').lesson_sections.first.day_of_week).to eq 'monday'
  end
end
