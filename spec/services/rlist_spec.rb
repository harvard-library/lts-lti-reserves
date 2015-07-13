
require 'rails_helper'
describe Rlist do
  describe "gets" do
    it "successfully gets a list of reserves" do
      WebMock.allow_net_connect!
      rlist = Rlist.new
      response = rlist.list('78419')
      expect(response.code).to eq(200)
#      puts response.body
      WebMock.disable_net_connect!
    end
    it "successfully gets a list of libraries" do
      WebMock.allow_net_connect!
      rlist = Rlist.new
      response = rlist.library_list
      input_list = JSON.parse(response.body)
      puts "count:  #{input_list.count}"
      expect(response.code).to eq(200)
      WebMock.disable_net_connect!
    end
  end
end
