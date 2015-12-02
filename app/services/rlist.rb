require 'httparty'
#require 'dotenv'
#Dotenv.load
class Rlist
  include RestHandler
  include HTTParty
  base_uri  ENV['RLIST_URL']
#  LIBRARY STUFF

  def library_list
    response = self.class.get("/libraries/",
                              :headers => {"User-Agent" => "lts-lti-reserves"} )
    handle_bad_response(response,"Unsuccessful  call for reserve ( #{res_id}). ") if response.code != 200
    response
  end
  def course_library(cid)
    response = self.class.get("/libraries/course/#{cid}",
                              :headers => {"User-Agent" => "lts-lti-reserves"} )
    handle_bad_response(response,"Unsuccessful library-for-course call (#{cid}. ") if response.code != 200 && response.code != 204
    json = response.code == 200 ? JSON.parse(response.body) : {}
  end

# RESERVE STUFF

  def reserve(res_id)
    response = self.class.get("/citationrequests/" + res_id.to_s ,
                              :headers => {"User-Agent" => "lts-lti-reserves"} )
    handle_bad_response(response,"Unsuccessful  call for reserve ( #{res_id}). ") if response.code != 200
    response
  end
  def delete(course_id, res_id)
    response = self.class.delete("/courses/#{course_id}/citationrequest/#{res_id}")
    handle_bad_response(response, "Problem deleting reserve( #{res_id})./courses/#{course_id}/citationrequests/#{res_id} ") if response.code != 204
  end
  def update(course_id, res_id,  options)
    loc = ("/courses/#{course_id}/citationrequest/#{res_id}")
    response = self.class.post(loc, { body: options,
                                 :headers => {"User-Agent" => "lts-lti-reserves"}} )
    handle_bad_response(response,"Unsuccessful update of Reserve ( #{res_id}). ") if response.code != 204 # || response.headers['Location'] != loc
    response
  end
  def reorder(course_id, sort_order)
    options = {"sort_order" => sort_order, "submittingSystem" => "CANVAS"}
    loc = ("/courses/#{course_id}/citationrequests/reorder")
    response = self.class.post(loc, { body: options,
                                 :headers => {"User-Agent" => "lts-lti-reserves"}} )
    handle_bad_response(response,"Unsuccessful attempt to reorder reserves.") if response.code !=204
    response
  end
  def create(course_id, options)
    loc = ("/courses/#{course_id}/citationrequest/")
    response =  self.class.post(loc, { body: options,
                                :headers => {"User-Agent" => "lts-lti-reserves"}} )
    handle_bad_response(response,"Problem creating new Reserve. ") if response.code != 201 # || response.headers['Location'] != loc
    response

  end
# COURSE STUFF
  def list(course_id)
    response = self.class.get("/courses/" + course_id.to_s + "/citationrequests",
                            :headers => {"User-Agent" => "lts-lti-reserves"} )
    handle_bad_response(response,"Unsuccessful  call for course ( #{course_id}). ") if response.code != 200

 #  raise ApiError.new(response.code, response.message), "Unable to get list for course (#{course_id})" if response.code != 200
    response
  end
# REQUEST HISTORY STUFF
  def history(reserve_id)
    response = self.class.get("/citationrequests/" + reserve_id.to_s + "/history",
                              :headers => {"User-Agent" => "lts-lti-reserves"} )
    handle_bad_response(response,"Unsuccessful  call for history for reserve (#{reserv_id}). ") if response.code != 200
    response
  end


end



#rlist = Rlist.new

#response =  rlist.list('351089')
#response =  rlist.list('35108900000000000000')
#puts response.code
#puts "body"
#puts response.body

#puts rlist.list('78419')
