def create_author_and_sign_in
  author = FactoryGirl.create :author
  login_as(author, :scope => :user)
end

def create_student_and_sign_in
  student = FactoryGirl.create :student
  login_as(student, :scope => :user)
end
