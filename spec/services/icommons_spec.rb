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
    it "gets a course instance from a URI" do
      id = "https://icommons.harvard.edu/api/course/v2/course_instances/320710/"
      WebMock.allow_net_connect!
      ic = Icommons.new
      json = ic.course_instance(id)
      WebMock.disable_net_connect!
      expect(json["course"]["course_id"]).to eq(76451)
      expect(json["course"]["school_id"]).to eq("colgsas") 
    end
  end


  describe "instances_from_course" do
    it "gets a course_instance_array" do
      WebMock.allow_net_connect!
      ic = Icommons.new
      ar = ic.instances_from_course('76451')
      WebMock.disable_net_connect!
      expect(ar.count).to eq(6)
    end
  end
end

