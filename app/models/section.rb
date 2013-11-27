class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  default_scope -> {order :number}

  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true, :numericality => {:only_integer => true}
  validates :chapter, :presence => true

  has_many :lessons, :dependent => :destroy
  belongs_to :chapter
end
