class CoursesController < ApplicationController
  def show
    @reserves = Course.new(params[:id]).list
  end
end
