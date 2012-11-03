require 'spec_helper'

describe 'when a student first visits the site' do
  context 'the page they see' do
    it 'has "Learn How To Program" as the title' do
      visit '/'
      page.should have_content "Learn How To Program"
    end
  end
end
