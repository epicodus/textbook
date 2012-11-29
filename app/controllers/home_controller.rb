class HomeController < ApplicationController
  def show
    if Lesson.accessible_by(current_ability).any?
      redirect_to Lesson.accessible_by(current_ability).first
    end
  end
end
