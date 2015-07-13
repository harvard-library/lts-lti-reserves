require 'rails_helper'
describe Library do
  describe "create" do
    it "creates a Library object" do
      opts= { "libraryCode" => "DIV", "name" => "Andover-Harvard Theol.", "contactEmail" => "reserves@hds.harvard.edu",
        "supportUrl" => "http://www.hds.harvard.edu/library/services/faculty/harvard_faculty_reserves.html"
      }
      lib = Library.new(opts)
      expect(lib.library_code).to eq("DIV")
      expect(lib.name).to eq("Andover-Harvard Theol.")
      expect(lib.contact_email).to eq("reserves@hds.harvard.edu")
      expect(lib.support_url).to eq("http://www.hds.harvard.edu/library/services/faculty/harvard_faculty_reserves.html")
    end
  end
end
