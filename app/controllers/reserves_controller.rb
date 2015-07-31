class ReservesController < ApplicationController
  def show
  end
  
  def update
    begin
#    logger.error  "****** #{params}"
#    logger.error "**reserve*** #{params[:reserve] => estimated_enrollment}"
      err_str = ""
      changed = false
      %w(estimated_enrollment, student_annotation, lecture_date, required, visibility).each |v| do
        changed = true if params["o_" + v] == params[:reserve][v.to_sym]
      end
      if !changed
        err_str = "No values were changed"
      else
        err_str = "Estimated Enrollment must be a number" if  params[:reserve][:estimated_enrollment] &&  params[:reserve][:estimated_enrollment] !~ /\A[+-]?\d+\z/
      end
      if !err_str
        flash[:error] = err_str
        redirect_to :action => :edit, id: params[:reserve][:citation_request_id]
      end
# OK, here's where we try to POST
      options = {
        body: {
          citation_request: {
            estimated_enrollment:  params[:reserve][:estimated_enrollment],
            student_annotation:  params[:reserve][:student_annotation],
            lecture_date:  params[:iso_date],
            required:   params[:reserve][:required],
            visibility:   params[:reserve][:visibility]
          }
        }
      }
      
rescue Exception => bang
    flash[:error] = "unable to update Reserve: #{bang}"
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
