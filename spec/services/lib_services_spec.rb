require 'rails_helper'
describe LibServices do
  describe "get" do
    it "successfully gets a citation" do
      WebMock.allow_net_connect!
      libs = LibServices.new
      response = libs.hollis_cite('003617028')
puts response.body
      cite = JSON.parse(response.body)['rlistFormat']['hollis']
      expect(response.code).to eq(200)
      expect(cite['hollisId'].start_with?('003617028')).to eq(true)
      expect(cite['year'].to_s).to eq("1994")
      WebMock.disable_net_connect!
    end
    it "tries to get something that isn't there" do
      WebMock.allow_net_connect!
      response = LibServices.new.hollis_cite('993617028')
      expect(response.code).to eq(404)
      WebMock.disable_net_connect!
    end
  end
end
