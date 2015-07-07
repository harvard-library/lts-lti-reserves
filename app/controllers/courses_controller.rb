class CoursesController < ApplicationController
  def show
    @reserves = Course.new(params[:id]).list
  end
  def delete
# deletion stuff to be added
    @reserves = Course.new(params[:id]).list
  end
end
