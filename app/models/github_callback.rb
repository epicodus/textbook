class GithubCallback
  include ActiveModel::Model

  attr_reader :event

  def initialize(params)
    @event = params
  end

  def push_to_master?
    branch == 'refs/heads/master'
  end

  def update_sections
    layouts_modified.each do |path|
      full_path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{path}"
      Section.where(layout_file_path: full_path).each do |section|
        section.try(:build_section)
      end
    end
  end

  def update_lessons
    update_modified_lessons
    update_removed_lessons
  end

private

  def branch
    event['ref']
  end

  def repo
    event['repository']['name']
  end

  def layouts_modified
    event['commits'].map { |commit| commit['modified'] }.flatten.select { |filename| filename.include?('yaml') }
  end

  def lessons_modified
    event['commits'].map { |commit| commit['added'] + commit['modified'] + commit['removed'] }.flatten.map { |filename| filename.gsub('_cheat.md', '.md').gsub('_teacher.md', '.md') }.uniq - layouts_modified - lessons_removed
  end

  def lessons_removed
    event['commits'].map { |commit| commit['removed'] }.flatten.select { |filename| !filename.include?('_cheat.md') && !filename.include?('_teacher.md') && !filename.include?('.yaml') }
  end

  def update_modified_lessons
    lessons_modified.each do |file|
      lessons = Lesson.where(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{file}")
      lessons.each do |lesson|
        lesson.update_from_github
        lesson.save
      end
    end
  end

  def update_removed_lessons
    lessons_removed.each do |filename|
      lessons = Lesson.where(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{filename}")
      lessons.update_all(content: 'Removed from Github', cheat_sheet: nil, teacher_notes: nil, public: false)
    end
  end
end
