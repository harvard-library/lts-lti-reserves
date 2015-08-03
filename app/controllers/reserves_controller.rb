class ReservesController < ApplicationController
  def show
  end
  
  def update
    begin
      err_str = ""
      changed = false
      %w{estimated_enrollment student_annotation lecture_date required visibility}.each do |v| 
        changed = true if params["o_" + v] != params[:reserve][v.to_sym] 
      end
      if !changed
        err_str = "No values were changed"
      else
        err_str = "Estimated Enrollment must be a number" if  params[:reserve]["estimated_enrollment"] &&  params[:reserve]["estimated_enrollment"] !~ /\A[+-]?\d+\z/
      end
      if err_str
        if !changed
          flash[:info] = err_str
        else
          flash[:error] = err_str
        end
        redirect_to '/reserves/' +  params[:reserve]["citation_request_id"] + '/edit?course_id=' + params[:reserve]["instance_id"]
      end
# OK, here's where we try to POST.  Note: camelCase for Java!
      options = {
          estimatedEnrollment:  params[:reserve][:estimated_enrollment],
          studentAnnotation:  params[:reserve][:student_annotation],
          lectureDate:  params[:iso_date],
          required:   params[:reserve][:required],
          visibility:   params[:reserve][:visibility],
          submittingSystem: "CANVAS"
      }
      begin
        resp = Rlist.new.update(params[:reserve]["instance_id"],params[:id], options)
        flash[:success] = "Updated Reserve #{params["title"]} (#{params[:reserve]["citation_request_id"]})"
        redirect_to '/courses/' +  params[:reserve]["instance_id"]
      end
    rescue Exception => bang
      flash[:error] = "Unable to update Reserve #{params["title"]} : #{bang}"
      redirect_to '/reserves/' + params[:id] +'?course_id=' + params[:reserve]["instance_id"]
    end
  end
  def edit
    # error handling coming soon: check for id, course_id match, etc.
    begin
      resp = Rlist.new.reserve(params[:id])
      @reserve  = Reserve.new(JSON.parse(resp.body))
    end
  rescue Exception => bang
    flash[:error] = "Unable to retrieve information on this Reserve (ID #{params[:id]}): #{bang}"
    redirect_to  '/courses/' + params[:course_id] 
  end

  def index
  end
end
