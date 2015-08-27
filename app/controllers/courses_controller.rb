class CoursesController < ApplicationController
  def show
    begin
      @reserves = Course.new(params[:id]).list
      @others = fetch_others(params[:id])
    end
  rescue Exception => bang
    flash[:error] = "Unable to retrieve information on Course Instance #{params[:id]}: #{bang}"
  end
  def previous
    begin
      # do all the good grabbing of reserves
      prev_reserves = Course.new(params[:id]).list
      json = Rlist.new.course_library(params[:id])
      lib_code = json['libraryCode']
      respond_to do |format|
        format.html do
          render :partial => 'courses/previous',
          :locals => {:prev_reserves => prev_reserves, :id => params[:id], :lib_code => lib_code }
        end
      end
    end
#  rescue Exception => bang
#    flash[:error] = "Unable to retrieve information on the previous course #{params[:id]}: #{bang}"

  end
  def previous_select
    begin
      others = fetch_others(params[:id])
      respond_to do |format|
        format.html do
          render :partial => 'courses/select_previous',
          :locals => { :others => others}
        end
      end
    end
#  rescue Exception => bang
#    flash[:error] = "Unable to retrieve information from iCommons on Course Instance #{params[:id]}: #{bang}"
  end
  def reuse
    # here's where all the re-usability magic happens!
    count = 0
    err_str = ""
    opts = {}
    opts["submittingSystem"] = "CANVAS"
    opts["estimatedEnrollment"] ="0"
    opts["libraryCode"] = params[:library_code]
    opts["contactInstructorId"] = params[:contact_instructor_id] || ENV['HUID'] # we'll get this when we hook up with LTI
    opts["instanceId"] = params[:id]
    if params[:cit_ids]
      params[:cit_ids].each do |cit_id|
        ret_str = reuse_one(opts, cit_id)
        if ret_str.empty?
          count = count + 1
        else
          err_str = "#{err_str}; #{ret_str}"
        end
      end
    end
    @reserves = Course.new(params[:id]).list
    flash[:notice] = "#{count} reserve#{'s' if count != 1} re-used"
    flash[:error] = err_str if !err_str.empty?
    redirect_to :action => :show, id: params[:id]
  end
  def reuse_one(opts, cit_id) 
    begin
      opts["citationId"] = cit_id
      @reserve = Reserve.new(opts)
      if !@reserve.valid?
        @reserve.errors[:base] if @reserve.errors[:base]
      else
       resp = Rlist.new.create(opts["instanceId"],options)
       ""
      end
    end
  rescue StandardError  => bang
    "Unable to create new Reserve from citation id #{cit_id} : #{bang}"
  end
  def delete_one(id, res_id)
    begin
      Rlist.new.delete(params[:id], res_id)
      ""
    end
    rescue StandardError => bang
    "#Reserve ID #{res_id} failed: #{bang}; "
  end
  def delete
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
# sometime I'll make this private, or a concern, or something!
  def fetch_others(id)
    ii =  InstanceInfo.new(id)
    ii.fill_others
    ii.others
  end
end
