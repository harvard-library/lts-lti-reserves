# Handles the Ecru Webservice Read-only API
require 'httparty'
class EcruServices
  include RestHandler
  include HTTParty
  base_uri   ENV['ECRU_URL']
  def course

  end

  def readings(course_id)
    response = fetch("/readings/courses/c_#{course_id}?rows=100")
    handle_bad_response(response,"Problem getting student readings for #{course_id}") if response.code != 200 && response.code != 404
    json = response.code == 200  ? JSON.parse(response.body) : {}
  end

  def fetch(fragment)
     response = self.class.get(fragment,
                              :headers => {"User-Agent" => "lts-lti-reserves",
                                "Accept" => "application/json"} )
    response
  end


end
