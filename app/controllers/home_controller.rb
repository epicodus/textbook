class HomeController < ApplicationController
  def show
    if Page.any?
      @page = Chapter.first.sections.first.pages.first
      render '/pages/show'
    end
  end
end
