require 'httparty'

#require 'dotenv'
#Dotenv.load
class Rlist
  include HTTParty
  base_uri    ENV['RLIST_URL'] || 'http://rlisttest.lib.harvard.edu:9008/rest/v1'

  def handle_bad_response(response, msg)
    if response && response.body
      err = MultiXml.parse(response.body)
      msg = "#{msg} #{err["error"]["status"]}"
#      msg = "#{msg} #{response.body}"
    else
      msg = "#{response.code}: #{response.message}"
    end
    raise RuntimeError.new(msg)
  end

  def library_list
    response = self.class.get("/libraries/",
                              :headers => {"User-Agent" => "lts-lti-reserves"} )
    handle_bad_response(response,"Unsuccessful  call for reserve ( #{res_id}). ") if response.code != 200
    response
  end
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
  def list(course_id)
    response = self.class.get("/courses/" + course_id.to_s + "/citationrequests",
                            :headers => {"User-Agent" => "lts-lti-reserves"} )
    handle_bad_response(response,"Unsuccessful  call for course ( #{course_id}). ") if response.code != 200

 #  raise ApiError.new(response.code, response.message), "Unable to get list for course (#{course_id})" if response.code != 200
    response
  end
  def update(res_id,  options)
    loc = ("/citationrequests/" + res_id.to_s)
    response self.class.post(loc, options,
                             :headers => {"User-Agent" => "lts-lti-reserves"} )
    handle_bad_response(response,"Unsuccessful update of Reserve ( #{res_id}). ") if response.code !204 || response.headers['Location'] != loc
  end
end

#rlist = Rlist.new

#response =  rlist.list('351089')
#response =  rlist.list('35108900000000000000')
#puts response.code
#puts "body"
#puts response.body

#puts rlist.list('78419')
