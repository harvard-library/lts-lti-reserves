require 'httparty'

#require 'dotenv'
#Dotenv.load
class Rlist
  include HTTParty
  base_uri    ENV['RLIST_URL'] || 'http://rlisttest.lib.harvard.edu:9008/rest/v1'

  def list(course_id)
    response = self.class.get("/courses/" + course_id.to_s + "/citationrequests",
                            :headers => {"User-Agent" => "lts-lti-reserves"} )
    if response.code != 200
      msg = "Unsuccessful  call for course ( #{course_id}). "
      if response
        err = MultiXml.parse(response.body)
        msg = "#{msg} #{err["error"]["status"]}"
      else
        msg = "#{response.code}: #{response.message}"
      end
      raise RuntimeError.new(msg);
    end
 #  raise ApiError.new(response.code, response.message), "Unable to get list for course (#{course_id})" if response.code != 200
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
