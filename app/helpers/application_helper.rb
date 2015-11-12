module ApplicationHelper

  def public_lessons_helper(object, &block)
    if can? :manage, Lesson
      object.lessons.each &block
    else
      object.lessons.only_public.each &block
    end
  end
end
