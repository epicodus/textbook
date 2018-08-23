class Track < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  default_scope -> { order :number }

  before_validation :set_number, on: :create
  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true

  has_and_belongs_to_many :courses

private

  def set_number
    self.number = Track.all.last.try(:number).to_i + 1
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
