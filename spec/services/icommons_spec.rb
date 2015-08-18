require 'rails_helper'
describe Icommons do
  describe "course instance" do
    it "successfully gets a course instance" do
      WebMock.allow_net_connect!
      ic = Icommons.new
      json = ic.course_instance('336909')
      puts json["course"]["course_id"]
      puts json["course"]["school_id"]
      expect(json["course"]["course_id"]).to eq(71345)
      expect(json["course"]["school_id"]).to eq("colgsas")
      WebMock.disable_net_connect!
    end
  end
end
