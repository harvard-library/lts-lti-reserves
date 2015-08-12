
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
    it "handles an empty library for course" do
      WebMock.allow_net_connect!
      rlist = Rlist.new
      json = rlist.course_library(34704)
      expect(json.empty?).to be(true)
    end 
    it "handles a successful library for course" do
      WebMock.allow_net_connect!
      rlist = Rlist.new
      json = rlist.course_library(347043)
      expect(json['contactEmail']).to eq("circinfo@hms.harvard.edu")
      expect(json['libraryCode']).to eq("MED")
    end
  end
end
