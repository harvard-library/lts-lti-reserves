require 'httparty'
#require 'dotenv'
#Dotenv.load
class Rlist
  include HTTParty
  base_uri    ENV['RLIST_URL'] || 'http://rlisttest.lib.harvard.edu:9008/rest/v1/citationrequests/'

  def list(course_id)
    response = self.class.get("/course/" + course_id.to_s,
                            :headers => {"User-Agent" => "lts-lti-reserves"} )
    raise RuntimeError.new("Unsuccessful  call to " + self.base_uri.to_s + " for course (" + course_id.to_s + ") with code " + response.code.to_s) if response.code != 200
    response
  end
end

#rlist = Rlist.new

#response =  rlist.list('35109900000')
#puts response.code
#puts "body"
#puts response.body

#puts rlist.list('78419')
