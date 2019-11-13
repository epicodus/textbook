require 'rails_helper'

RSpec.describe GithubLessonReaderJob, type: :job do
  include ActiveJob::TestHelper

  before(:each) do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      GithubLessonReaderJob.perform_later
    }.to have_enqueued_job(GithubLessonReaderJob)
  end

  it "executes lesson.update_from_github" do
    lesson = FactoryBot.build(:lesson, github_path: "https://github.com/#{ENV['GITHUB_CURRICULUM_ORGANIZATION']}/testing/blob/master/README.md")
    allow_any_instance_of(GithubReader).to receive(:pull_lesson).and_return({:content=>"test content", :cheat_sheet=>nil, :teacher_notes=>nil, :video_id=>nil})
    expect(Lesson).to receive(:update_from_github).with(lesson)
    lesson.save
    perform_enqueued_jobs { GithubLessonReaderJob.perform_later(lesson) }
  end
end
