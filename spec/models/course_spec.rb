require 'rails_helper'

describe Course do
  describe "create" do
    it "successfully creates a list of reserves" do
      id = 355726
      WebMock.allow_net_connect!
      c = Course.new(id)
      WebMock.disable_net_connect!
      expect(c.reserves.count).to eq(2)
    end
    it "creates a list of reserves without deletes" do
      id = 345486
      WebMock.allow_net_connect!
      c = Course.new(id)
      WebMock.disable_net_connect!
      c.no_deletes
      expect(c.reserves.count).to eq(12)
    end
    it "creates the same list WITH deletes" do
      id = 345486
      WebMock.allow_net_connect!
      c = Course.new(id)
      WebMock.disable_net_connect!
      expect(c.reserves.count).to eq(13)
    end
    it "creates a student list" do
      id = 356403     
      WebMock.allow_net_connect!
      c = Course.new(id)
      WebMock.disable_net_connect!
      expect(c.student_list.count).to eq(5)
    end

  end
end
