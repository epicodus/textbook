class Page < ActiveRecord::Base
  acts_as_paranoid

  default_scope order('sort_order')

  attr_accessible :title, :body, :section_id, :sort_order

  validates :title, :presence => true
  validates :body, :presence => true
  validates :sort_order, :presence => true, :numericality => {:only_integer => true}
  validates :section, :presence => true

  belongs_to :section

  def next
    Page.where('sort_order > ?', sort_order).first
  end

  def previous
    Page.where('sort_order < ?', sort_order).last
  end
end
