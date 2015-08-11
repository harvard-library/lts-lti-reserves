# Handles the Webservices Read-only API
require 'httparty'
class LibServices
  include RestHandler
  include HTTParty
  base_uri   ENV['LIB_SERVICES_URL'] || 'http://webservices.lib.harvard.edu/rest/cite'

  def journal_cite(id)
    id = CGI.escape(id)
    response = fetch_cite("/journal/#{id}")
    json = ""
    json = JSON.parse(response.body)['rlistFormat']['journalArticle'] if response.code == 200
    cite_from_json(response.code,json)
  end

  def hollis_cite(id)
    response = fetch_cite("/hollis/#{id}")
    json = ""
    json = JSON.parse(response.body)['rlistFormat']['hollis'] if response.code == 200
    cite_from_json(response.code, json)
  end


  # calls to both hollis and journal end up the same way, so why not say so? :-)
  def fetch_cite(fragment)
    response = self.class.get(fragment,
                              :headers => {"User-Agent" => "lts-lti-reserves",
                                "Accept" => "application/json"} )
    handle_bad_response(response,"Problem getting cite for #{id}") if response.code != 200 && response.code != 404
    response
  end
 
  # process the input json (if it exists, returning a "cite" hash that's ready to go!)
  def cite_from_json(code, json)
    cite = {}
    cite["status"] = code
    if code == 200
      json.each do |k, v|
        if k == "authors" 
          author =  v["authorName"]
          if !author.nil?
            author =  author[0] if author.kind_of?(Array)
            cite["author_first_name"] =  author["authorFirst"] || ""
            cite["author_last_name"] =  author["authorLast"] || ""
          end
          editor= v["editorName"]
          if !editor.nil?
            editor = editor[0] if editor.kind_of?(Array)
            cite["editor_first_name"] = editor["editorFirst"] || ""
            cite["editor_last_name"] =  editor["editorLast"] || ""
          end
        elsif k == "isbn"
          cite["isbn"] = ""
          if v.kind_of?(Array)
            v.each { |i| cite["isbn"] = "#{cite["isbn"]} #{i},"}
            cite["isbn"].chop!.strip!
          else
            cite["isbn"] = v
          end
        elsif k == "articleTitle"
          cite["title"] = v
        elsif k == "pubInfo"
          cite["publisher"] = v
        elsif k == "hollisId"
          cite["hollis_system_number"] = v.to_s
        elsif k == "pmc"
          cite["pmc"] = v
          cite["url"] = "http://www.ncbi.nlm.nih.gov/pmc/articles/#{v}"
        else
          cite[k.underscore] = v.to_s
        end
      end
    end
    cite #return cite
  end
end
