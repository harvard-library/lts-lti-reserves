# Handles the Webservices Read-only API
require 'httparty'
class LibServices
  include RestHandler
  include HTTParty
  base_uri   ENV['LIB_SERVICES_URL'] || 'http://webservices.lib.harvard.edu/rest/cite'

  def journal_cite(id)
    jid = CGI.escape(id)
    fetch_cite("/journal/#{jid}")
  end

  def hollis_cite(id)
    fetch_cite("/hollis/#{id}")
  end

  # calls to both hollis and journal end up the same way, so why not say so? :-)
  def fetch_cite(fragment)
    response = self.class.get(fragment,
                              :headers => {"User-Agent" => "lts-lti-reserves",
                                "Accept" => "application/json"} )
    handle_bad_response(response,"Problem getting HOLLIS cite for #{id}") if response.code != 200 && response.code != 404
    response
  end

end
