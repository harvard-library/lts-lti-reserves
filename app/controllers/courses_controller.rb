class CoursesController < ApplicationController
  def show
    begin
      @reserves = Course.new(params[:id]).list
    end
  rescue Exception => bang
    flash[:error] = "Unable to retrieve information on Course Instance #{params[:id]}: #{bang}"
  end

  def delete_one(id, res_id)
    begin
      Rlist.new.delete(params[:id], res_id)
      ""
    end
    rescue Exception => bang
    "#Reserve ID #{res_id} failed: #{bang}; "
  end
  def delete
puts "DELETE"
    count = 0
    err_str = ""
    if params[:res_ids]
      params[:res_ids].each do |res_id|
        ret_str = delete_one(params[:id], res_id)
        if ret_str.empty?
          count = count + 1 
        else
          err_str = "#{err_str}; #{ret_str}"
        end
      end
    end
    @reserves = Course.new(params[:id]).list
    flash[:notice] = "#{count} reserve#{'s' if count != 1} deleted"
    flash[:error] = err_str if !err_str.empty?
    redirect_to :action => :show, id: params[:id]
  end
  def reorder
    begin
      resp = Rlist.new.reorder( params[:id], params[:sort_order])
      flash[:notice] = "Reserves reordered"
    rescue Exception => bang
      flash[:error] = bang
    end
    redirect_to :action => :show, id: params[:id]
  end
end
