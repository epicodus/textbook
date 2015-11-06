require 'spec_helper'

describe LessonHelper do
  context '#markdown' do
    it 'turns Markdown in HTML' do
      expect(markdown('*markdown*')).to eq "<p><em>markdown</em></p>\n"
    end
  end
end
