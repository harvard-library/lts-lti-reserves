require 'rails_helper'
describe Citation do
  describe "create" do
    it "successfully creates a new JOURNAL Citation by symbol" do
      cit = Citation.new({:citation_id => "2", :citation_type=> "JOURNAL", :title=>"My Veryfine Journal"})
      expect(cit.citation_id).to eq("2")
      expect(cit.citation_type).to eq("JOURNAL")
      expect(cit.title).to eq("My Veryfine Journal")
    end
    it "successfully creates a new NONJOURNAL Citation by camelCase ignoring bad field" do
      cit = Citation.new({"citationId" => "34", "citationType"=> "NON_JOURNAL", "foo" => "bar", "title" => "A new documentary"})
      expect(cit.citation_id).to eq("34")
      expect(cit.citation_type).to eq("NON_JOURNAL")
    end
   it "successfully creates a new NONJOURNAL Citation by as if from JSON" do
      cit = Citation.new({
    "alephUrl" => "007827307",
    "citationId" => "350602",
    "citationType" => "NON_JOURNAL",
    "isbn" => "0700710817",
    "pageNumbers" => "xxxvii, 329 p.;",
    "publicationYear" => "1999",
    "publisher" => "Curzon",
    "title" => "American Buddhism: methods and findings in recent scholarship"
                         });
      expect(cit.citation_id).to eq("350602")
      expect(cit.citation_type).to eq("NON_JOURNAL")
      expect(cit.title).to eq( "American Buddhism: methods and findings in recent scholarship")
    end
  end
end
