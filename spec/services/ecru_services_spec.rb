require 'rails_helper'
describe EcruServices do
  describe "course readings" do
    it "successfully gets readings for a course" do
      WebMock.allow_net_connect!
      ec = EcruServices.new
      json = ec.readings(309627)
      WebMock.disable_net_connect!
      expect(json["items"][0]["id"]).to eq("r_303624")
    end
  end
end
