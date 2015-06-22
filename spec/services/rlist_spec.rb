
require 'rails_helper'
describe Rlist do
  describe "gets" do
    it "successfully gets a list" do
      WebMock.allow_net_connect!
      rlist = Rlist.new
      response = rlist.list('78419')
      expect(response.code).to eq(200)
      WebMock.disable_net_connect!
    end
  end
end
