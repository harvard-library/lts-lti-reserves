class CoursesController < ApplicationController
  def show
    @reserves = Course.new(params[:id]).list
  end
  def delete
    count = 0
    if params[:res_ids]
      params[:res_ids].each do |res_id|
# TBD: handling errors!
        Rlist.new.delete(params[:id], res_id)
        count = count + 1
      end
    end

    @reserves = Course.new(params[:id]).list
    flash[:notice] = "#{count} reserve#{'s' if count != 1} deleted"
    redirect_to :action => :show, id: params[:id]
  end
end
