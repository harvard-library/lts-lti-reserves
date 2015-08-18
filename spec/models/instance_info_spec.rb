require 'rails_helper'

describe InstanceInfo do
  describe "create" do
    it "successfully constructs itself as a primary" do
      id = 356987
      WebMock.allow_net_connect!
      ii = InstanceInfo.new(id)
      WebMock.disable_net_connect!
      expect(ii.course_id).to eq(77231)
      expect(ii.catalog).to eq("HLS-2470")
      expect(ii.title).to eq("Law and Philosophy Seminar")
      expect(ii.term).to eq("Fall 2015")
      expect(ii.primary).to be_nil
      expect(ii.xreg_ids.count).to eq(2)
    end
    it "successfully constructs itself as a secondary" do
      id = 360017

      WebMock.allow_net_connect!
      ii = InstanceInfo.new(id)
      WebMock.disable_net_connect!
      expect(ii.course_id).to eq(76451)
      expect(ii.catalog).to eq("FAS-113481")
      expect(ii.title).to eq("PHIL 277: Law and Philosophy Colloquium")
      expect(ii.primary).to eq(356987)
    end
  end
end
