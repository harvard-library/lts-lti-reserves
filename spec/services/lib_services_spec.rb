require 'rails_helper'
describe LibServices do
  describe "hollis" do
    it "successfully gets a hollis citation" do
      WebMock.allow_net_connect!
      libs = LibServices.new
      response = libs.hollis_cite('003617028')
puts response.body
      cite = JSON.parse(response.body)['rlistFormat']['hollis']
      expect(response.code).to eq(200)
      expect(cite['hollisId'].start_with?('003617028')).to eq(true)
      expect(cite['year'].to_s).to eq("1994")
      WebMock.disable_net_connect!
    end
    it "tries to get something that isn't there" do
      WebMock.allow_net_connect!
      response = LibServices.new.hollis_cite('993617028')
      expect(response.code).to eq(404)
      WebMock.disable_net_connect!
    end
  end
  describe "journal" do
    it "successfully gets a doi" do
      WebMock.allow_net_connect!
      libs = LibServices.new
      response = libs.journal_cite("10.1016/j.pedn.2008.07.009")
      cite = JSON.parse(response.body)['rlistFormat']['journalArticle']
      expect(response.code).to eq(200)
      expect(cite['doi']).to eq("10.1016/j.pedn.2008.07.009")
      expect(cite['journalTitle']).to eq("Journal of Pediatric Nursing")
      expect(cite['pubmed']).to be_nil
      WebMock.disable_net_connect!
    end
    it "successfully gets a PUBMED article" do
      WebMock.allow_net_connect!
      response = LibServices.new.journal_cite("11079970")
      cite = JSON.parse(response.body)['rlistFormat']['journalArticle']
      expect(response.code).to eq(200)
      expect(cite['pubmed'].to_s).to eq("11079970")
      expect(cite['doi']).to be_nil
      WebMock.disable_net_connect!
    end
  end
 
end
