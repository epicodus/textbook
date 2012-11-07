class Page < ActiveRecord::Base
  default_scope order('sort_order')

  attr_accessible :title, :body, :section_id, :sort_order

  validates :title, :presence => true
  validates :body, :presence => true
  validates :sort_order, :presence => true, :numericality => {:only_integer => true}

  belongs_to :section
end
