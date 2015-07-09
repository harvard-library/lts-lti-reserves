class CoursesController < ApplicationController
  def show
    @reserves = Course.new(params[:id]).list
  end
  def delete
# deletion stuff to be added
    @reserves = Course.new(params[:id]).list
    flash[:notice] = "#{params[:reserve_ids].count} reserves deleted"
    redirect_to :action => :show, id: params[:id]
  end
end
