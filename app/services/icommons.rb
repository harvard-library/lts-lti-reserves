require 'httparty'
class Icommons
 include RestHandler
  include HTTParty
  base_uri    ENV['ICOMMONS_URL']

  @@auth =  ENV['ICOMMONS_AUTH']
  @@headers = {"User-Agent" => "lts-lti-reserves", 
    "Authorization" => @@auth, 
    "Accept" => "application/json"}

  def course_instance(cid)
    response = self.class.get("/course_instances/#{cid}/",
                              :headers => @@headers)
    # need to log the bad response, but not now!
    json = response.code == 200 ? JSON.parse(response.body) : {}
  end
end
