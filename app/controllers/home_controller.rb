class HomeController < ApplicationController
  def show
    if Lesson.any?
      redirect_to Lesson.accessible_by(current_ability).first
    end
  end
end
