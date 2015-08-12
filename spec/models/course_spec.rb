require 'rails_helper'

describe Course do
  describe "create" do
    it "successfully creates a list of reserves" do
      id = 355726
      WebMock.allow_net_connect!
      c = Course.new(id)
      WebMock.disable_net_connect!
      expect(c.reserves.count).to eq(1)
    end
    it "creates a list of reserves without deletes" do
      id = 345486
      WebMock.allow_net_connect!
      c = Course.new(id)
      WebMock.disable_net_connect!
      expect(c.reserves.count).to eq(12)
    end
    it "creates the same list WITH deletes" do
      id = 345486
      WebMock.allow_net_connect!
      c = Course.new(id, true)
      WebMock.disable_net_connect!
      expect(c.reserves.count).to eq(13)
    end
    it "creates a list sorted by instructor_sort_order" do
      id = 336909     
      WebMock.allow_net_connect!
      c = Course.new(id, true)
      WebMock.disable_net_connect!
      expect(c.list[0].instructor_sort_order).to eq("0")
    end
  end
end
