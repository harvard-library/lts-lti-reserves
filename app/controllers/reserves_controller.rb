class ReservesController < ApplicationController
  def show
  end
  
  def new
    @course_id = params[:course_id] ||  params[:reserve]["instance_id"]
# get library list (libs), default library (lib_def) here
    @libs = Library::library_options
    @material_types = Reserve.material_types
    @reserve = Reserve.new({:instance_id => @course_id})
  end
  def create
    @reserve = Reserve.new(params[:reserve])
    if !@reserve.valid?
      flash.now[:error] = @reserve.errors[:base] if @reserve.errors[:base]
      @libs = Library::library_options
    @material_types = Reserve.material_types
      render "new"
    end
  end
  def update
    begin
      err_str = ""
      changed = false
      %w{estimated_enrollment student_annotation lecture_date required visibility}.each do |v| 
        changed = true if params["o_" + v] != params[:reserve][v.to_sym] 
      end
      flash[:info] = "No values were changed" if !changed
      flash[:error] = "Estimated Enrollment must be a number" if  params[:reserve]["estimated_enrollment"] &&  params[:reserve]["estimated_enrollment"] !~ /\A[+-]?\d+\z/
      redir = '/reserves/' + params[:reserve]["citation_request_id"] + '/edit?course_id=' + params[:reserve]["instance_id"] if flash[:info] || flash[:error]

# OK, here's where we try to POST.  Note: camelCase for Java!
      if !redir
        begin
          options = {
            estimatedEnrollment:  params[:reserve][:estimated_enrollment],
            studentAnnotation:  params[:reserve][:student_annotation],
            lectureDate:  params[:iso_date],
            required:   params[:reserve][:required],
            visibility:   params[:reserve][:visibility],
            submittingSystem: "CANVAS"
          }
          resp = Rlist.new.update(params[:reserve]["instance_id"],params[:id], options)
        rescue StandardError  => bang
          flash[:error] = "Unable to update Reserve #{params["title"]} : #{bang}"
          redir = '/reserves/' + params[:id] + '/edit?course_id=' + params[:reserve]["instance_id"]
        else
          flash[:success] = "Updated Reserve #{params["title"]} (#{params[:reserve]["citation_request_id"]})"
          redir = '/courses/' +  params[:reserve]["instance_id"]
        end
      end        
      redirect_to redir
    end
  end

  def edit
    # error handling coming soon: check for id, course_id match, etc.
    begin
      resp = Rlist.new.reserve(params[:id])
      @reserve  = Reserve.new(JSON.parse(resp.body))
    rescue StandardError => bang
      flash[:error] = "Unable to retrieve information on this Reserve (ID #{params[:id]}): #{bang}"
      redirect_to  '/courses/' + params[:course_id] 
    else
      @reserve
    end
  end

  def index
  end
end
