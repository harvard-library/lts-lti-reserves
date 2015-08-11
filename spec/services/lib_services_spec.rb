require 'rails_helper'
describe LibServices do
  describe "hollis" do
    it "successfully gets a hollis citation" do
      WebMock.allow_net_connect!
      libs = LibServices.new
      cite = libs.hollis_cite('003617028')
      expect(cite["status"]).to eq(200)
      expect(cite['hollis_system_number'].start_with?('003617028')).to eq(true)
      expect(cite['year']).to eq("1994")
      expect(cite['title']).to eq("The Internet guide for new users")
      WebMock.disable_net_connect!
    end
    it "tries to get something that isn't there" do
      WebMock.allow_net_connect!
      cite = LibServices.new.hollis_cite('993617028')
      expect(cite["status"]).to eq(404)
      WebMock.disable_net_connect!
    end
    it "tried to get something with an editor and author" do
      WebMock.allow_net_connect!
      cite = LibServices.new.hollis_cite('001254979')
puts cite
      expect(cite["status"]).to eq(200)
      expect(cite['author_last_name']).to eq("Maimonides")
      expect(cite['author_first_name']).to eq("Moses")
      expect(cite['editor_last_name']).to eq("Twersky")
      expect(cite['editor_first_name']).to eq("Isadore")
      expect(cite['publisher']).to eq("New York: Behrman House")
      expect(cite['isbn']).to eq("0874412064 (pbk.), 874412005")
    end
  end
  describe "journal" do
    it "successfully gets a doi" do
      WebMock.allow_net_connect!
      libs = LibServices.new
      cite = libs.journal_cite("10.1016/j.pedn.2008.07.009")
      expect(cite["status"]).to eq(200)
      expect(cite['doi']).to eq("10.1016/j.pedn.2008.07.009")
      expect(cite['journal_title']).to eq("Journal of Pediatric Nursing")
      expect(cite['pubmed']).to be_nil
      WebMock.disable_net_connect!
    end
    it "successfully gets a PUBMED article" do
      WebMock.allow_net_connect!
      cite = LibServices.new.journal_cite("11079970")
puts cite
      expect(cite["status"]).to eq(200)
      expect(cite['pubmed'].to_s).to eq("11079970")
      expect(cite['doi']).to be_nil
      expect(cite['end_page']).to eq("684")
      expect(cite['author_last_name']).to eq("Reilly")
      expect(cite['title']).to eq("A knowledge-based patient assessment system: conceptual and technical design.")
      expect(cite['url']).to eq("http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2243964")
      WebMock.disable_net_connect!
    end
  end
end
