require 'rails_helper'
describe Icommons do
  describe "course instance" do
    it "successfully gets a course instance" do
      WebMock.allow_net_connect!
      ic = Icommons.new
      json = ic.course_instance('336909')
      WebMock.disable_net_connect!
      expect(json["course"]["course_id"]).to eq(71345)
      expect(json["course"]["school_id"]).to eq("colgsas")
    end
  end
  describe "instances_from_course" do
    it "gets a course_instance_array" do
      WebMock.allow_net_connect!
      ic = Icommons.new
      ar = ic.instances_from_course('76451')
      WebMock.disable_net_connect!
puts ar
    end
  end
end

