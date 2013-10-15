class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  default_scope -> {order :number}

  attr_accessible :name, :number, :chapter_id, :public

  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true, :numericality => {:only_integer => true}
  validates :chapter, :presence => true

  has_many :lessons, :dependent => :destroy
  belongs_to :chapter
end
