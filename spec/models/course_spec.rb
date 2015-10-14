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
      expect(c.student_list.count).to eq(4)
    end
    it "handles ordering correctly" do
      id = 371158
      WebMock.allow_net_connect!
      c = Course.new(id)
      WebMock.disable_net_connect!
      list = c.student_list
      expect(c.ins_sortable?).to eq(true)
      expect(list.count).to eq(7)
      expect(Integer(list[0].instructor_sort_order || "0")).to eq(0)
      expect(Integer(list[1].instructor_sort_order || "0")).to eq(8)
      expect(Course.list_has_dates?(list)).to eq(true)
      expect(Course.list_has_ins_order?(list)).to eq(true)
    end
  end
end
