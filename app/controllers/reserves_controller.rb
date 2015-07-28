class ReservesController < ApplicationController
  def show
  end
  
  def update
    begin
#    logger.error  "****** #{params}"
#    logger.error "**reserve*** #{params[:reserve] => estimated_enrollment}"
      @reserve = params[:reserve][:estimated_enrollment]
    end
rescue Exception => bang
    flash[:error] = "problem: #{bang}"
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
