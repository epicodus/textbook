class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  default_scope -> { order :number }

  before_validation :set_number, on: :create

  validates :name, :presence => true, uniqueness: { scope: :course }
  validates :number, :presence => true
  validates :course, :presence => true
  validate :name_does_not_conflict_with_routes

  has_many :lesson_sections, inverse_of: :section
  has_many :lessons, through: :lesson_sections
  belongs_to :course

  def export_lessons
    directory = Rails.root.join('tmp', self.name.parameterize)
    Dir.mkdir(directory) unless File.exists?(directory)
    self.lessons.each_with_index do |lesson, index|
      lesson_name = index.to_s + "-" + LessonSection.find_by(lesson: lesson, section: self).day_of_week + "-" + lesson.name.parameterize
      lesson_name.prepend("0") if index < 10
      lesson_name = lesson_name + "-HIDDEN" if !lesson.public
      File.open(File.join(directory, "#{lesson_name}.md"), 'w') do |f| f.puts lesson.content end
      if lesson.cheat_sheet && lesson.cheat_sheet.strip != ""
        File.open(File.join(directory, "#{lesson_name}-cheat-sheet.md"), 'w') do |f| f.puts lesson.cheat_sheet end
      end
      if lesson.teacher_notes && lesson.teacher_notes.strip != ""
        File.open(File.join(directory, "#{lesson_name}-teacher-notes.md"), 'w') do |f| f.puts lesson.teacher_notes end
      end
    end
    zipfile_name = directory.to_s + "-" + Time.now.utc.iso8601.to_s + ".zip"
    zip_directory(directory, zipfile_name)
    return zipfile_name
  end

private

  def zip_directory(directory, zipfile_name)
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      Dir.entries(directory).each do |filename|
        if filename != '.' && filename != '..'
          begin
            zipfile.add(filename, "#{directory}/#{filename}")
          rescue Zip::ZipEntryExistsError
          end
        end
      end
    end
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def set_number
    self.number = course.try(:sections).try(:last).try(:number).to_i + 1
  end

  def name_does_not_conflict_with_routes
    conflicting_names = ['sections', 'lessons', 'courses']
    if conflicting_names.include?(name.try(:downcase))
      errors.add(:name, "cannot be #{name}")
      false
    end
  end
end
