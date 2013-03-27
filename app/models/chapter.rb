class Chapter < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  acts_as_paranoid

  default_scope order :number

  attr_accessible :name, :number, :public, :sections_attributes, :lessons_attributes

  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true, :numericality => {:only_integer => true}

  has_many :sections, :dependent => :destroy
  has_many :lessons, :through => :sections

  accepts_nested_attributes_for :sections
  accepts_nested_attributes_for :lessons
end
