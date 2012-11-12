class Page < ActiveRecord::Base
  acts_as_paranoid

  default_scope order('number')

  attr_accessible :title, :body, :section_id, :number

  validates :title, :presence => true
  validates :body, :presence => true
  validates :number, :presence => true, :numericality => {:only_integer => true}
  validates :section, :presence => true

  belongs_to :section

  def next
    Page.where(:section_id => section.id).where('number > ?', number).first
  end

  def previous
    Page.where(:section_id => section.id).where('number < ?', number).last
  end
end
