class GithubCallback
  include ActiveModel::Model

  attr_reader :event

  def initialize(params)
    @event = params
  end

  def push_to_master?
    branch == 'refs/heads/master'
  end

  def update_all
    update_sections({ repo: repo, paths: layout_files_modified }) # update sections when layout file updated
    update_lessons({ repo: repo, modified: files_modified, removed: files_removed }) # update individual lessons
  end

  def update_sections(repo:, paths:)
    paths.each do |path|
      full_path = "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{path}"
      section = Section.find_by(layout_file_path: full_path)
      section.try(:build_section)
    end
  end

  def update_lessons(params)
    update_modified_lessons(params[:repo], params[:modified]) if params[:modified].try(:any?)
    update_removed_lessons(params[:repo], params[:removed]) if params[:removed].try(:any?)
  end

private

  def branch
    event['ref']
  end

  def repo
    event['repository']['name']
  end

  def files_modified
    event['commits'].map { |commit| commit['added'] + commit['modified'] }.flatten.uniq
  end

  def files_removed
    event['commits'].map { |commit| commit['removed'] }.flatten.uniq
  end

  def layout_files_modified
    files_modified.select { |path| path.include?('yaml') }
  end

  def update_modified_lessons(repo, files)
    files.each do |file|
      lessons = Lesson.where(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{file}")
      lessons.each do |lesson|
        lesson.update_from_github
        lesson.save
      end
    end
  end

  def update_removed_lessons(repo, files)
    files.each do |file|
      lesson = Lesson.find_by(github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/#{repo}/blob/master/#{file}")
      lesson.update_columns(public: false) if lesson
    end
  end
end
