class CoursesController < ApplicationController
  def show
    begin
      params[:viewonly] = "true"
      c  = Course.new(params[:id])
      @reserves = c.student_list
    rescue Exception => bang
      bangmsg = bang.to_s
      if bangmsg.include? "404 - Not Found"
        bangmsg = "Course instance does not exist in the Reserves Tool database"
      end
      flash[:error] = "Unable to retrieve information on Course Instance #{params[:id]}: #{bangmsg}"
    end
    begin
      @instance = fetch_info(params[:id])
    rescue StandardError => bang
      flash[:notice] = "Unable to retrieve Course details: #{bang}"
    end
  end

  def edit
    redirect_to :action => :show, id: params[:id] and return if !can_edit?(current_user, params[:id])
    begin
      c  = Course.new(params[:id])
      @reserves = c.list
    rescue Exception => bang
      bangmsg = bang.to_s
      if bangmsg.include? "404 - Not Found"
        bangmsg = "Course instance does not exist in the Reserves Tool database"
      end
      flash[:error] = "Unable to retrieve information on Course Instance #{params[:id]}: #{bangmsg}"
    end
    begin
      @instance = fetch_info(params[:id])
      @others = fetch_others(@instance)
    rescue StandardError => bang
      flash[:notice] = "Unable to retrieve information on previous Instances: #{bang}"
    end
    rescue StandardError => bang
      flash[:notice] = "Unable to retrieve Course details: #{bang}"
  end
  def previous
    begin
      # do all the good grabbing of reserves
      c =  Course.new(params[:prev_id])
      c.list
      c.author_sort
      prev_reserves = c.reserves
      json = Rlist.new.course_library(params[:id])
      lib_code = json['libraryCode']
      if lib_code.blank? && prev_reserves.length > 0 
        lib_code = prev_reserves[0].library_code
      end
    rescue StandardError => bang
      flash[:error] = "Unable to retrieve information on the previous course #{params[:id]}: #{bang}"
      redirect_to  :action => :edit, id: params[:id] and return
    end
    respond_to do |format|
      format.html do
        render :partial => 'courses/previous',
        :locals => {:prev_reserves => prev_reserves, :id => params[:id], :lib_code => lib_code, :course_title => params[:course_title] }
      end
    end
  end
  def previous_select
    begin
      others = fetch_others(params[:prev_id])
    rescue Exception => bang
      flash[:error] = "Unable to retrieve information from iCommons on Course Instance #{params[:id]}: #{bang}"
       redirect_to  :action => :edit, id: params[:id]
    end
    respond_to do |format|
      format.html do
        render :partial => 'courses/select_previous',
        :locals => { :others => others, :id => params[:id]}
      end
    end
  end
  def reuse
    redirect_to :action => :show, id: params[:id] and return if !can_edit?(current_user, params[:id])
    # here's where all the re-usability magic happens!
    count = 0
    errs = []
    opts = {}
    opts["submittingSystem"] = "CANVAS"
    opts["estimatedEnrollment"] ="0"
    opts["contactInstructorId"] = current_user.lis_person_sourcedid || ENV['HUID'] # we'll get this when we hook up with LTI
    opts["contactInstructorIdType"] = "HUID"
    opts["instanceId"] = params[:id]
    opts["visibility"] = "P"
    opts["status"]= "REUSE"
    if params[:reuse_ids]
      params[:reuse_ids].each do |reuse_id|
        ret_str = reuse_one(opts, reuse_id)
        if ret_str.empty?
          count = count + 1
        else
          errs.push(ret_str)
        end
      end
    end
#    @reserves = Course.new(params[:id]).list
    flash[:notice] = "#{count} reserve#{'s' if count != 1} re-used"
    flash[:error] = errs if !errs.blank?
    redirect_to :action => :edit, id: params[:id] and return
  end
  def reuse_one(opts, reuse_id) 
    begin
      resp = Rlist.new.reserve(reuse_id)
      reuse_reserve = JSON.parse(resp.body)
      reuse_reserve.each do |k, v|
        if k.is_a?(String) && k.starts_with?("input")
          if !v.blank?
            opts[k] = v
          end
        end
      end
      opts["libraryCode"]  = reuse_reserve["libraryCode"]
      opts["citationId"] = reuse_reserve["citationId"]
      opts["required"] = reuse_reserve["required"]
      @reserve = Reserve.new(opts)
      if !@reserve.valid?
        errors = "Unable to create new Reserve from previous_reserve_id #{reuse_id}: #{errmessage(@reserve.errors.messages)}" if !@reserve.errors.messages.blank?
      else
        resp = Rlist.new.create(opts["instanceId"],opts)
        log_post(opts["instanceId"],reuse_id,"REUSE")
        ""
      end
    end
  rescue StandardError  => bang
    "Unable to create new Reserve from  previous_reserve_id #{reuse_id}: #{bang}"
  end
  def delete_one(id, res_id)
    redirect_to :action => :show, id: params[:id] and return if !can_edit?(current_user, params[:id])
    begin
      Rlist.new.delete(params[:id], res_id)
      log_post(params[:id], res_id, "DELETE")
      ""
    end
  rescue StandardError => bang
    "#Reserve ID #{res_id} failed: #{bang}; "
  end
  def delete
    redirect_to :action => :show, id: params[:id] and return if !can_edit?(current_user, params[:id])
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
    redirect_to :action => :edit, id: params[:id]
  end
  def reorder
    redirect_to :action => :show, id: params[:id] and return if !can_edit?(current_user, params[:id])
    begin
      resp = Rlist.new.reorder( params[:id], params[:sort_order])
      log_post(params[:id],"#{params[:sort_order]}","REORDER")
      flash[:notice] = "Reserves reordered"
    rescue StandardError => bang
      flash[:error] = bang
    end
    redirect_to :action => :edit, id: params[:id] 
  end
  def slash
#    flash[:error] = "We got to slash!"
    redirect_to :action => :show, id: session[:lis_course_offering_sourcedid]
  end

# sometime I'll make this private, or a concern, or something!
  def fetch_info(id)
    ii = InstanceInfo.new(id)
  end
  def fetch_others(ii)
    ii.fill_others
    ii.others
  end
# another thing for concerns, eventually
  def errmessage(messages)
    errs = ""
    messages.each do |k,v|
      if !v.blank?
        errs = "#{errs} #{v.join}"
      end
    end
    errs
  end
end
