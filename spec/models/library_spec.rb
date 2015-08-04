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
  describe "list with webmocking" do
    before(:all) do
      body = ""
      File.open("spec/libraries_mock.txt", "r") do |file|
        while line = file.gets
          body = body + line if !line.start_with?("#")
        end
      end
      WebMock.stub_request(:get, "http://rlisttest.lib.harvard.edu:9008/rest/v1/libraries/").
        with(:headers => {'User-Agent'=>'lts-lti-reserves'}).
        to_return(:status => 200, :body => body, :headers => {})
    end
    it "works with the before" do
      list = Library::library_list
      expect(list.count).to eq(5)
    end
    it "gets options list" do
      list = Library::library_options
      expect(list.count).to eq(5)
      expect(list[2][0]).to eq("Botany")
      expect(list[2][1]).to eq("BOT")
    end
    it "gets a library off the list" do
      lib = Library::fetch_library("BIO")
      expect(lib).not_to eq(nil)
      expect(lib.name).to eq("Biological Labs")
      expect(lib.library_code).to eq("BIO")
      expect(lib.contact_email).to eq("bioill@fas.harvard.edu")
      expect(lib.support_url).to eq("http://hcl.harvard.edu/info/reserves/#contact")
    end
  end
    
end

