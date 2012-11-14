class Section < ActiveRecord::Base
  acts_as_paranoid

  default_scope order('number')

  attr_accessible :name, :number, :chapter_id

  validates :name, :presence => true
  validates :number, :presence => true, :numericality => {:only_integer => true}

  has_many :pages
  belongs_to :chapter

  def next
    Section.where(:chapter_id => chapter.id).where('number > ?', number).first
  end

  def previous
    Section.where(:chapter_id => chapter.id).where('number < ?', number).last
  end
end
