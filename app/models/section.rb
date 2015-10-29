class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  default_scope -> { order :number }

  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true, :numericality => { :only_integer => true }
  validates :chapter, :presence => true
  validate :not_named_section

  has_many :lesson_sections
  has_many :lessons, through: :lesson_sections
  belongs_to :chapter

private

  def not_named_section
    if name.try(:downcase) == 'section'
      errors.add(:name, "cannot be section")
      false
    end
  end
end
