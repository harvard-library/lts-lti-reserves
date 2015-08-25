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
    loc = !cid.to_s.match(/^\d+$/)  ? cid : "/course_instances/#{cid}/" 
    response = self.class.get(loc,
                              :headers => @@headers)
    # need to log the bad response, but not now!
    json = response.code == 200 ? JSON.parse(response.body) : {}
  end
  def instances_from_course(id)
    loc = !id.to_s.match(/^\d+$/) ? id : "/courses/#{id}" 
    response = self.class.get(loc,
                              :headers => @@headers)
    # need to log the bad response, but not now!
    json = response.code == 200 ? JSON.parse(response.body) : {}
    json["course_instances"] ?  json["course_instances"].sort { |a,b| a.slice(/\d\d+/).to_i <=> b.slice(/\d\d+/).to_i }.reverse
                             : []
  end
end
