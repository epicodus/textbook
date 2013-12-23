require 'spec_helper'

describe LessonHelper do
  context '#markdown' do
    it 'turns Markdown in HTML' do
      markdown('*markdown*').should eq "<p><em>markdown</em></p>\n"
    end
  end
end
