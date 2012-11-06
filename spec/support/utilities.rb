def create_author_and_sign_in
  author = FactoryGirl.create :author
  visit '/'
  click_link 'sign in'
  fill_in 'Email', with: author.email
  fill_in 'Password', with: author.password
  click_button 'Sign in'
end

def create_student_and_sign_in
  student = FactoryGirl.create :student
  visit '/'
  click_link 'sign in'
  fill_in 'Email', with: student.email
  fill_in 'Password', with: student.password
  click_button 'Sign in'
end
