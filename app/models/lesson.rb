class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  acts_as_paranoid

  default_scope order('number')

  attr_accessible :name, :content, :section_id, :number, :public

  validates :name, :presence => true, :uniqueness => true
  validates :content, :presence => true
  validates :number, :presence => true, :numericality => {:only_integer => true}
  validates :section, :presence => true

  belongs_to :section

  def next
    Lesson.where('number > ?', number).first
  end

  def previous
    Lesson.where('number < ?', number).last
  end

  def next_lesson?
    self.next != nil
  end

  def previous_lesson?
    self.previous != nil
  end
end
