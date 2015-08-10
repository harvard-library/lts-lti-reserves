module RestHandler
# right now, this only handles bad responses, but who knows what the future brings :-)
  def handle_bad_response(response, msg)
    if response && msg && response.body
      err = MultiXml.parse(response.body)
      msg = "#{msg} #{err["error"]["status"]} #{err["error"]["message"]}"
#      msg = "#{msg} #{response.body}"
    else
      msg = "#{msg} #{response.code}: #{response.message}"
    end
   raise RuntimeError.new(msg)
  end
end
