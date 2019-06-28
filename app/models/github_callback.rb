class GithubCallback
  include ActiveModel::Model

  attr_reader :event

  def initialize(params)
    @event = params
  end

  def update_lessons
    GithubReader.update_sections({ repo: repo, directories: directories_updated }) # update sections
    Github.update_lessons({ repo: repo, modified: files_modified, removed: files_removed }) # update individual lessons (legacy)
  end

  def push_to_master?
    branch == 'refs/heads/master'
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

  def files_touched
    files_modified + files_removed
  end

  def directories_updated
    unique_directories(files_touched)
  end

  def unique_directories(paths)
    paths.select { |path| path.include?('/') }.map {|path| path.split('/').first}.uniq
  end
end
