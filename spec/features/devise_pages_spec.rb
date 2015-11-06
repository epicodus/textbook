require 'spec_helper'

describe 'logging in' do
  it 'works' do
    student = FactoryGirl.create :student
    visit new_user_session_path
    fill_in 'Email', with: student.email
    fill_in 'Password', with: student.password
    click_button 'Sign in'
    expect(page).to have_content "Signed in successfully."
  end
end
