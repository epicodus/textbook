class Course < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  default_scope -> { order :number }
  scope :with_sections, -> { includes(:sections).where.not(sections: { id: nil }) }

  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true

  has_many :sections, :dependent => :destroy
  has_many :lessons, :through => :sections

  accepts_nested_attributes_for :sections
  accepts_nested_attributes_for :lessons
end
