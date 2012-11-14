class Section < ActiveRecord::Base
  acts_as_paranoid

  default_scope order('number')

  attr_accessible :name, :number, :chapter_id

  validates :name, :presence => true
  validates :number, :presence => true, :numericality => {:only_integer => true}

  has_many :pages
  belongs_to :chapter
end
