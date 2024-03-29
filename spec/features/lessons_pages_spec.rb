require 'spec_helper'

describe Lesson do
  context 'viewing' do
    let(:author) { FactoryBot.create :author }
    let(:student) { FactoryBot.create :student }
    let!(:section) { FactoryBot.create :section }
    let!(:lesson) { FactoryBot.create :lesson, section: section }

    it 'can be viewed by a student' do
      login_as(student, scope: :user)
      visit course_path(section.course)
      click_link section.name
      click_link lesson.name
      expect(page).to have_content lesson.content
    end

    it "shows teacher notes section to teachers" do
      login_as(author, scope: :user)
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to have_content lesson.teacher_notes
    end

    it "doesn't show teacher notes section to students" do
      login_as(student, scope: :user)
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page.html).to_not match lesson.teacher_notes
    end

    it "shows 404 if lesson not found" do
      login_as(student, scope: :user)
      lesson.destroy
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to have_content 'Page not found'
    end

    it "links to github path, if available, for teachers" do
      lesson.update_columns(github_path: 'example.com')
      login_as(author, scope: :user)
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to have_selector(:css, 'a[href="example.com"]')
    end

    it "does not link to github path for students" do
      lesson.update_columns(github_path: 'example.com')
      login_as(student, scope: :user)
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to_not have_selector(:css, 'a[href="example.com"]')
    end
  end

  context 'when it is not public' do
    let(:author) { FactoryBot.create :author }
    let(:student) { FactoryBot.create :student }
    let!(:section) { FactoryBot.create :section }

    before { login_as(author, scope: :user) }

    it 'is visible to an author' do
      lesson = FactoryBot.create :lesson, section: section, public: false
      visit course_section_lesson_path(section.course, section, lesson)
      expect(page).to have_content lesson.content
    end

    it 'is not visible to a student' do
      login_as(student, scope: :user)
      private_lesson = FactoryBot.create :lesson, section: section, public: false
      public_lesson = FactoryBot.create :lesson, section: section
      visit course_section_lesson_path(section.course, section, private_lesson)
      expect(page).to have_content "Sorry, that lesson isn't finished yet."
    end

    it 'is not visible on the course show page' do
      login_as(student, scope: :user)
      private_lesson = FactoryBot.create :lesson, section: section, public: false
      public_lesson = FactoryBot.create :lesson, section: section
      visit course_path(section.course)
      expect(page).to_not have_content private_lesson.content
    end

    it 'is not visible on the section show page' do
      login_as(student, scope: :user)
      private_lesson = FactoryBot.create :lesson, section: section, public: false
      public_lesson = FactoryBot.create :lesson, section: section
      visit course_section_path(section.course, section)
      expect(page).to_not have_content private_lesson.content
    end
  end

  context 'lesson disambiguation' do
    let(:track) { FactoryBot.create :track }
    let(:course) { FactoryBot.create :course, tracks: [track] }
    let(:section) { FactoryBot.create :section, course: course }
    let!(:lesson) { FactoryBot.create :lesson, section: section, content: 'lesson 1 content' }
    
    context 'without referrer url' do
      it 'shows list of courses lesson belongs to' do
        course_2 = FactoryBot.create :course, tracks: [track]
        section_2 = FactoryBot.create :section, course: course_2
        lesson_2 = FactoryBot.create :lesson, section: section_2, name: lesson.name
        visit lesson_path(lesson)
        expect(page).to have_content lesson.name
        expect(page).to have_content course.name
        expect(page).to have_content lesson_2.section.course.name
      end

      it 'prepends part-time if course description contains part-time' do
        course.update(name: 'JavaScript Part-Time')
        visit lesson_path(lesson)
        expect(page).to have_content 'Part-Time: '
      end

      it 'prepends full-time if course description does not contain part-time' do
        visit lesson_path(lesson)
        expect(page).to have_content 'Full-Time: '
      end

      it 'allows navigation to lesson' do
        visit lesson_path(lesson)
        click_on course.name
        expect(page).to have_content lesson.content
      end

      it 'informs user if no lesson found' do
        visit lesson_path('non-existent-lesson')
        expect(page).to have_content '404'
      end
    end

    context 'with referrer url' do  
      it 'routes to the correct lesson' do
        lesson_same_course = FactoryBot.create(:lesson, section: section, content: "<a href='/lessons/#{lesson.slug}'>link to lesson</a>")
        visit course_section_lesson_path(lesson_same_course.section.course, lesson_same_course.section, lesson_same_course)
        click_on 'link to lesson'
        expect(page).to have_content lesson.content
        expect(current_path).to eq course_section_lesson_path(lesson.section.course, lesson.section, lesson)
      end

      it 'routes to the correct lesson when same lesson in multiple courses' do
        lesson_same_course = FactoryBot.create(:lesson, section: section, content: 'should see this')
        lesson_other_course = FactoryBot.create(:lesson, section: FactoryBot.create(:section), name: lesson_same_course.name, content: 'should not see this')
        lesson.update(content: "<a href='/lessons/#{lesson_other_course.slug}'>link to lesson</a>")
        visit course_section_lesson_path(lesson.section.course, lesson.section, lesson)
        click_on 'link to lesson'
        expect(page).to have_content 'should see this'
        expect(current_path).to eq course_section_lesson_path(lesson_same_course.section.course, lesson_same_course.section, lesson_same_course)
      end

      it 'informs user if no lesson found in that section' do
        lesson_other_course = FactoryBot.create(:lesson, section: FactoryBot.create(:section), content: "<a href='/lessons/#{lesson.slug}'>link to lesson</a>")
        visit course_section_lesson_path(lesson_other_course.section.course, lesson_other_course.section, lesson_other_course)
        click_on 'link to lesson'
        expect(page).to have_content '404'
      end
    end
  end

  context 'searching' do
    let!(:lesson) { FactoryBot.create :lesson }

    it 'lets you search for lessons' do
      visit courses_path
      fill_in 'Search lessons', with: lesson.content.split.last
      click_on 'lesson-search'
      expect(page).to have_content lesson.name
    end
  end

  context 'redirecting' do
    it 'redirects from lessons index to courses index when there are no params' do
      visit lessons_path
      expect(page.current_path).to eq courses_path
    end
  end
end
