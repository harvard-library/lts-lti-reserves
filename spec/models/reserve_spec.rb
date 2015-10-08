require 'rails_helper'

describe Reserve do
  describe "create" do
    it "creates reserve with no citation: a chapter in a book with all chapter info in input only BUT set as JOURNAL and no Library" do
      opts = {"contactInstructorId" => "70663473",
        "inputMaterialType" => "Book",
        "inputCitationType" => "JOURNAL",
        "inputTitle" => "Molecular Epidemiology: Principles and Practices ",
        "inputEditorLastName" => "Rothman",
        "inputEditorFirstName" => "Nathaniel",
        "inputChapterTitle" => "Combining molecular and genetic data from different sources",
        "inputChapterAuthorLastName" => "Ntzani",
        "inputChapterAuthorFirstName" => "Evangelia E",
        "instance_id" => "312287",
        "estimated_enrollment" => "0"
      }
      res = Reserve.new(opts)
      res.valid?
      expect(res.errors.messages[:base].find_index("Journal Reserve minimum: Article Title AND Journal Title OR URL")).not_to be_nil
      expect(res.errors.messages[:library_code]).not_to be_nil
    end
    it "creates reserve with no citation: a chapter in a book with all chapter info in input only AND set as NON_JOURNAL" do
      opts = {"contactInstructorId" => "70663473",
               "library_code" => "BOT",
               "inputMaterialType" => "Book",
               "inputCitationType" => "NON_JOURNAL",
               "inputTitle" => "Molecular Epidemiology: Principles and Practices ",
               "inputEditorLastName" => "Rothman",
               "inputEditorFirstName" => "Nathaniel",
               "inputChapterTitle" => "Combining molecular and genetic data from different sources",
               "inputChapterAuthorLastName" => "Ntzani",
               "inputChapterAuthorFirstName" => "Evangelia E",
               "instance_id" => "312287",
               "estimated_enrollment" => "0"
      }
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.author).to be_nil
      expect(res.editor).to eq("Rothman, Nathaniel.")
      expect(res.chapter_title).to eq("Combining molecular and genetic data from different sources")
      expect(res.chapter_author).to eq("Ntzani, Evangelia E.")
      expect(res.tip_title).to eq("Combining molecular and genetic data from different sources")
      expect(res.persisted?).to eq(false)
      expect(res.sort_title).to eq("combining molecular and genetic data from different sources")
    end
    it "creates reserve *with* a citation: a chapter in a book with all chapter info in input only" do
      opts = {
        "citation" => {
          "alephUrl" =>  "http://lms01.harvard.edu/F/?func=item-global&doc_library=HVD01&doc_number=013520485",
          "citationId" => "490161",
          "citationType" => "NON_JOURNAL",
          "editorFirstName" => "Nathaniel",
          "editorLastName" => "Rothman",
          "hollisSystemNumber" => "013520485",
          "isbn" => "978-92-832-2163-0",
          "materialType" => "BOOK",
          "year" => "2011",
          "publisher" => "International Agency for Research on Cancer",
          "title" => "Molecular Epidemiology: Principles and Practices"
        },
        "contactInstructorId" => "70663473",
        "citationId" => "490161",
        "citationRequestId" => "298659",
        "library_code" => "BOT",
        "inputMaterialType" => "Book",
        "inputTitle" => "Molecular Epidemiology: Principles and Practices ",
        "inputEditorLastName" => "Rothman",
        "inputChapterTitle" => "Combining molecular and genetic data from different sources",
        "inputChapterAuthorLastName" => "Ntzani",
        "inputChapterAuthorFirstName" => "Evangelia E",
        "instance_id" => "312287"
      }
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.author).to be_nil
      expect(res.editor).to eq("Rothman, Nathaniel.")
      expect(res.chapter_title).to eq("Combining molecular and genetic data from different sources")
      expect(res.chapter_author).to eq("Ntzani, Evangelia E.")
      expect(res.citation).to be_a Citation
      expect(res.journal?).to eq(false)
      expect(res.isbn).to eq("978-92-832-2163-0")
      expect(res.persisted?).to eq(true)
      expect(res.id).to eq("298659")
      expect(res.to_param).to eq("298659")
      expect(res.aleph_url).to eq("http://lms01.harvard.edu/F/?func=item-global&doc_library=HVD01&doc_number=013520485")
    end
    it "begins its title with a stop word" do
      opts = {"contactInstructorId" => "70663473",
        "inputMaterialType" => "Book",
        "inputTitle" => "An Issue to Be Considered: TLT",
        "instanceId" =>   "355238",
        "libraryCode" => "LAM",
        "required" => "Y",
        "visibility" => "true"}
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.input_citation_type).to eq("NON_JOURNAL")
      expect(res.display_status).to eq("Unknown")
      expect(res.sort_title).to eq("issue to be considered tlt")
    end
    it "begins its title with a stop word" do
      opts = {"contactInstructorId" => "70663473",
        "inputMaterialType" => "Book",
        "inputTitle" => "The ultimate guide to TLT's direction",
        "instanceId" =>   "355238",
        "libraryCode" => "LAM",
        "required" => "Y",
        "visibility" => "true"}
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.input_citation_type).to eq("NON_JOURNAL")
      expect(res.display_status).to eq("Unknown")
      expect(res.sort_title).to eq("ultimate guide to tlts direction")
    end
    it "creates a non-citationed reserve with material type, no type" do
      opts = {"contactInstructorId" => "70663473",
        "inputMaterialType" => "Book",
        "inputTitle" => "Everything You Wanted to Know About TLT: A Guide",
        "instanceId" =>   "355238",
        "libraryCode" => "LAM",
        "required" => "Y",
        "visibility" => "true"}
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.input_citation_type).to eq("NON_JOURNAL")
      expect(res.display_status).to eq("Unknown")
      expect(res.sort_title).to eq("everything you wanted to know about tlt a guide")
    end
    it "comes in with a citation author and url" do
      opts =  {
        "citation" => {
          "alephUrl" => "010778910",
          "authorLastName" => "Alcock",
          "citationId" => "408963",
          "citationType" => "NON_JOURNAL",
          "editorFirstName" => "Susan E.",
          "editorLastName" => "Alcock",
          "isbn" => "9780631234180 (hardback => alk. paper)",
          "materialType" => "BOOK",
          "pageNumbers" => "xiii, 447 p.",
          "year" => "2007",
          "publisher" => "Malden, MA: Blackwell Pub.",
          "title" => "Classical archaeology",
          "url" => "http://www.loc.gov/catdir/toc/ecip072/2006032271.html"
        },
        "citationId" => "408963",
        "citationRequestId" => "347314",
        "contactInstructorId" => "UNKNOWN",
        "contactInstructorIdType" => "HUID",
        "estimatedEnrollment" => "0",
        "inputCitationType" => "NON_JOURNAL",
        "instanceId" => "351019",
        "instanceIdType" => "COURSE",
        "inputPublisher" => "Malden Pres",
        "libraryCode" => "DIV",
        "required" => "Y",
        "status" => "COMPLETE",
        "submittedDate" => "2015-01-20T15:36:05.000+0000",
        "submittingSystem" => "HUL",
        "visibility" => "P"
      }
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.author).to eq("Alcock.")
      expect(res.dig_url).to eq("http://www.loc.gov/catdir/toc/ecip072/2006032271.html")
      expect(res.title).to eq("Classical archaeology")
      expect(res.display_status).to eq("Available")
      expect(res.publisher).to eq("Malden, MA: Blackwell Pub.")
      expect(res.year).to eq("2007")
    end
    it "comes in with a citation with full author" do
      opts = {
         "citation" => {
           "alephUrl" => "008434262",
           "authorFirstName" => "Mary Taliaferro",
          "authorLastName" => "Boatwright",
          "citationId" => "75646",
          "citationType" => "NON_JOURNAL",
          "isbn" => "0691048894 (cloth => alk. paper)",
          "materialType" => "BOOK",
          "pageNumbers" => "xviii, 243 p. :",
          "year" => "2000",
          "publisher" => "Princeton University Press",
          "title" => "Hadrian and the cities of the Roman empire",
          "url" => "http://www.loc.gov/catdir/toc/prin032/99041096.html"
        },
        "citationId" => "75646",
        "citationRequestId" => "347316",
        "contactInstructorId" => "UNKNOWN",
        "contactInstructorIdType" => "HUID",
        "estimatedEnrollment" => "0",
        "inputCitationType" => "NON_JOURNAL",
        "instanceId" => "351019",
        "instanceIdType" => "COURSE",
        "libraryCode" => "DIV",
        "required" => "Y",
        "status" => "COMPLETE",
        "submittedDate" => "2015-01-20T15:36:05.000+0000",
        "submittingSystem" => "HUL",
        "visibility" => "P"
      }
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.author).to eq("Boatwright, Mary Taliaferro.")
      expect(res.title).to eq("Hadrian and the cities of the Roman empire")
    end
    it "comes without a citation but title and author" do
      opts = {
        "citationId" => "",
        "citationRequestId" => "348489",
        "contactInstructorId" => "40421939",
        "contactInstructorIdType" => "HUID",
        "estimatedEnrollment" => "15",
        "inputAuthorFirstName" => "Michael",
        "inputAuthorLastName" => "Tabor",
        "inputCitationType" => "NON_JOURNAL",
        "inputHollisSystemNumber" => "001818775",
        "inputIsbn" => "471827282",
        "inputPublisher" => "New York: Wiley",
        "inputTitle" => "Chaos and integrability in nonlinear dynamics: an introduction",
        "inputYear" => "1989",
        "instanceId" => "351720",
        "instanceIdType" => "COURSE",
        "instructorSortOrder" => "1",
        "libraryCode" => "PHY",
        "required" => "Y",
        "status" => "NEW",
        "submittedDate" => "2015-01-25T18:20:44.000+0000",
        "submittingSystem" => "ICOMMONS",
        "visibility" => "P"
      }
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.title).to eq("Chaos and integrability in nonlinear dynamics: an introduction")
      expect(res.author).to eq("Tabor, Michael.")
    end
    it "is a reuse case" do
      opts = {"contactInstructorId" => "70663473",
        "status" => "REUSE",
        "citationId" =>  "75646",
        "libraryCode" => "CAB",
        "instanceId" => "78419"
      }
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
    end
    it "comes in with a citation" do
      opts = {"contactInstructorId" => "70663473",
        "inputCitationId"=>"349098",
        "instanceId" => "78419",
        "inputCitationType" => "NON_JOURNAL",
        "inputHollisSystemNumber" => "005117959",
        "citationId" => "349098",
        "citation" => {"alephUrl"=>"005117959",
          "citationId"=>"349098",
          "citationType"=>"NON_JOURNAL",
          "pageNumbers"=>"3 videocassettes (120 min.) :",
          "year"=>"1982",
          "publisher"=>"Center for South Asian Studies",
          "title"=>"Tibetan Buddhism"},
        "courseStatus" => "Deletion Requested",
        "input_title"=>"Tibetan Buddhism",
        "input_material_type" => "Video",
        "library_code" => "LAM",
        "status" => "DR_COMPLETE"
      }
      res = Reserve.new(opts)
      expect(TestHelper::valid(res)).to eq(true)
      expect(res.input_title).to eq("Tibetan Buddhism")
      expect(res.display_status).to eq("Deletion Requested")
    end
  end
  describe "library" do
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
    it "tests for handling library info" do
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
          "year"=>"1982",
          "publisher"=>"Center for South Asian Studies",
          "title"=>"Tibetan Buddhism"},
        "courseStatus" => "Deletion Requested",
        "input_title"=>"Tibetan Buddhism",
        "input_material_type" => "Video",
        "status" => "DR_COMPLETE",
        "libraryCode" => "BIO"
      }
      reserve = Reserve.new(opts)
      expect(reserve.valid?).to eq(true)
      expect(reserve.library.name).to eq("Biological Labs")
      expect(reserve.library.support_url).to eq("http://hcl.harvard.edu/info/reserves/#contact")

    end
  end
end
