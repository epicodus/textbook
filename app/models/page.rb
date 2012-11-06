class Page < ActiveRecord::Base
  attr_accessible :title, :body, :section_id

  validates :title, :presence => true
  validates :body, :presence => true

  belongs_to :section
end
