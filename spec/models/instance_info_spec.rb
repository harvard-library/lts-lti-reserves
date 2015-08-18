require 'rails_helper'

describe InstanceInfo do
  describe "create" do
    it "successfully constructs itself" do
      id = 356987
      WebMock.allow_net_connect!
      ii = InstanceInfo.new(id)
      WebMock.disable_net_connect!
      expect(ii.course_id).to eq(77231)
      expect(ii.title).to eq("Law and Philosophy Seminar")
      expect(ii.term).to eq("Fall 2015")
      expect(ii.primary).to be_nil
      expect(ii.xreg_ids.count).to eq(2)
    end
  end
end
