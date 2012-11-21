class Chapter < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  acts_as_paranoid

  default_scope order('number')

  attr_accessible :name, :number

  validates :name, :presence => true, :uniqueness => true
  validates :number, :presence => true, :numericality => {:only_integer => true}

  has_many :sections
end
