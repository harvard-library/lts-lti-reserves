require 'rails_helper'
describe Reserve do
  describe "create" do
    it "creates a non-citationed reserve with material type, no type" do
      opts = {"contactInstructorId" => "70663473",
     "inputMaterialType" => "Book",
     "inputTitle" => "Everything you wanted to know about TLT",
     "instanceId" =>   "355238",
     "libraryCode" => "LAM",
     "required" => "Y",
        "visibility" => "true"}
      res = Reserve.new(opts)
      expect(res.input_citation_type).to eq("NON_JOURNAL")
      end
    it "comes in with a citation" do
      opts = {"contactInstructorId" => "70663473",
        "inputAlephUrl" => "005117959",
        "inputCitationId"=>"349098",
        "instanceId" => "78419",
        "inputCitationType" => "NON_JOURNAL",
        "citationId" => "349098",
        "citation" => {"alephUrl"=>"005117959",
          "citationId"=>"349098",
          "citationType"=>"NON_JOURNAL",
          "pageNumbers"=>"3 videocassettes (120 min.) :",
          "publicationYear"=>"1982",
          "publisher"=>"Center for South Asian Studies",
          "title"=>"Tibetan Buddhism"},
        "input_title"=>"Tibetan Buddhism",
        "input_material_type" => "Video"
      }
      res = Reserve.new(opts)
      expect(res.input_title).to eq("Tibetan Buddhism")
    end
  end
end
