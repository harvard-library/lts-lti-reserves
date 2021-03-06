class ReservesController < ApplicationController
  def show
    resp = Rlist.new.reserve(params[:id])
    @reserve = Reserve.new(JSON.parse(resp.body))
    @course_id = params[:course_id] || @reserve.instance_id
    layout = false;
    if params[:layout]
      layout = true
    end
    if !params[:student]
      @history = fetch_history(params[:id])
    else
      @history = {}
    end
    render :action => "show", :layout => layout
  end
  
  def new
    @course_id = params[:course_id] ||  params[:reserve]["instance_id"]
    if !can_edit?(current_user, @course_id)
      flash[:error]="At this time, you are not authorized to add a Reserve to this course"
      redirect_to '/courses/' +  @course_id and return 
    end
# get library list (libs), default library (lib_def) here
    @libs = Library::library_options
    @material_types = Reserve.material_types
    instructor = current_user.lis_person_sourcedid || ENV['HUID'] # we'll get this when we hook up with LTI
    course_lib = Rlist.new.course_library(@course_id)
    lib = course_lib.empty? ? "" : course_lib['libraryCode']
    @reserve = Reserve.new({:instance_id => @course_id, :contact_instructor_id => instructor, :library_code => lib})
  end

  def create
    if params[:reserve][:instance_id].blank?
      params[:reserve][:instance_id] = params[:course_id]
    end
     if !can_edit?(current_user,  params[:reserve][:instance_id])
      flash[:error]="At this time, you are not authorized to add a Reserve to this course"
      redirect_to '/courses/' +  params[:reserve]["instance_id"] and return
    end
    params[:reserve][:lecture_date] =  params[:iso_date] if !params[:iso_date].blank?
    @reserve = Reserve.new(params[:reserve])
    if !@reserve.valid?
      flash.now[:error] = @reserve.errors[:base] if @reserve.errors[:base]
      @libs = Library::library_options
      @material_types = Reserve.material_types
      @course_id = params[:course_id]
      render "new"
      return
    else
      begin
        redir = ''
        options = {}
        Reserve::FIELDS.each do |k|
          v = @reserve.send(k)
          if !v.blank?
            options[k.to_s.camelize(first_letter =:lower)] = v
          end
        end
        if !options["inputHollisSystemNumber"].blank?
          options["inputHollisSystemNumber"] = options["inputHollisSystemNumber"].split("-")[0]
        end
        options["lectureDate"] = params[:iso_date]  if !params[:iso_date].blank?
        options["submittingSystem"] = "CANVAS"
        options["estimatedEnrollment"] ="0" if @reserve.estimated_enrollment.blank?
        resp = Rlist.new.create(params[:course_id], options)
        log_post(params[:course_id],"","CREATE")
        ""
      rescue StandardError  => bang
        flash[:error] = "Unable to create new Reserve #{params["title"]} : #{bang}"
        @libs = Library::library_options
        @material_types = Reserve.material_types
        @course_id = params[:course_id]
        render "new"
        return
      else
        flash[:success] = "Created new Reserve #{params["title"]} "
        redirect_to '/courses/' +  params[:reserve]["instance_id"] + '/edit'
      end
    end
  end

  def update
    if !can_edit?(current_user,  params[:reserve]["instance_id"])
      flash[:error]="At this time, you are not authorized to update  a Reserve to this course"
      redirect_to '/courses/' +  params[:reserve]["instance_id"] and return
    end
    begin
      err_str = ""
      changed = false
      %w{estimated_enrollment student_annotation lecture_date required visibility}.each do |v| 
        changed = true if params["o_" + v] != params[:reserve][v.to_sym] 
      end
      flash[:info] = "No values were changed" if !changed
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
          log_post(params[:reserve]["instance_id"],params[:id],"UPDATE")
          ""
        rescue StandardError  => bang
          flash[:error] = "Unable to update Reserve #{params["title"]} : #{bang}"
          redir = '/reserves/' + params[:id] + '/edit?course_id=' + params[:reserve]["instance_id"]
        else
          flash[:success] = "Updated Reserve #{params["title"]} (#{params[:reserve]["citation_request_id"]})"
          redir = '/courses/' +  params[:reserve]["instance_id"] + '/edit'
        end
      end        
      redirect_to redir
    end
  end

  def edit
    if !can_edit?(current_user, params[:course_id])
      flash[:error]="At this time, you are not authorized to update a Reserve to this course"
      redirect_to '/courses/' +  params[:course_id] and return
    end
    # error handling coming soon: check for id, course_id match, etc.
    begin
      resp = Rlist.new.reserve(params[:id])
      @reserve  = Reserve.new(JSON.parse(resp.body))
    rescue StandardError => bang
      flash[:error] = "Unable to retrieve information on this Reserve (ID #{params[:id]}): #{bang}"
      redirect_to  '/courses/' + params[:course_id] + '/edit'
    else
      @reserve
    end
  end

  def index
  end


 # AJAX
  def fetch_cite
    cite = {}
    results = {}
    type = params["type"]
    id = params[:id]
    begin
      if (type == "journal")
        cite = LibServices.new.journal_cite(id)
        Reserve::NEW_FIELDS.each do |field|
          results["reserve_input_#{field['name']}"] = cite[field['name']] if cite[field['name']] && (field["journal"].nil? || field["journal"])
        end
      elsif (type == "hollis")
        cite = LibServices.new.hollis_cite(id)
        Reserve::NEW_FIELDS.each do |field|
          results["reserve_input_#{field['name']}"] = cite[field['name']] if cite[field['name']] && !field["journal"]
        end
      end
      cite['status'] = "Item not found" if !cite['status'] || cite['status'] == 404
      results['status'] = cite['status']
      render :json => results.as_json
    end
  rescue RuntimeError => bang
    cite["status"] = bang
    render :json => cite.as_json(:except => "mods_date")
  end

  def fetch_history(id) 
      resp = Rlist.new.history(id)
      hist = JSON.parse(resp.body)
  end

end
