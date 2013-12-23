require 'spec_helper'

describe LessonHelper do
  context '#markdown' do
    it 'turns Markdown in HTML' do
      markdown('`code`').should =~ /<code>code<\/code>/
    end
  end
end
