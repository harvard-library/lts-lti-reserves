# Handles the Webservices Read-only API
require 'httparty'
class LibServices
  include RestHandler
  include HTTParty
  base_uri   ENV['LIB_SERVICES_URL'] || 'http://webservices.lib.harvard.edu/rest'

  def hollis_cite(hollis_id)
    response = self.class.get("/cite/hollis/#{hollis_id}",
                              :headers => {"User-Agent" => "lts-lti-reserves", 
                              "Accept" => "application/json"} )
    handle_bad_response(response,"Problem getting HOLLIS cite for #{hollis_id}") if response.code != 200 && response.code != 404
    response
  end

end
