class HomeController < ApplicationController
  def index
    if Page.all.any?
      @page = Section.first.pages.first
      render '/pages/show'
    end
  end
end
