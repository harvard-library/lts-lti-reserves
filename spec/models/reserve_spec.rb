require 'rails_helper'
describe Reserve do
  describe "create" do
    it "creates a non-citationed reserve " do
      opts = {"contactInstructorId" => "70663473",
     "inputMaterialType" => "Book",
     "inputTitle" => "Everything you wanted to know about TLT",
     "libraryCode" => "LAM",
     "required" => "Y",
        "visibility" => "true"}
      res = Reserve.new(opts)

      end
  end
end
