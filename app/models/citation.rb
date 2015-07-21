class Citation
  include ActiveModel::Model

# opts conversion thanks to http://chrisholtz.com/blog/lets-make-a-ruby-hash-map-method-that-returns-a-hash-instead-of-an-array/
  @@fields =  [:citation_id, 
                :citation_type, # either JOURNAL or NON_JOURNAL
                            :aleph_url,
                            :author_first_name,
                            :author_last_name,
                            :chapter_author_first_name,#non-journal
                            :chapter_author_last_name,#non-journal
                            :chapter_title,#non-journal
                            :day,# journal
                            :doi,# journal
                            :edition,#non-journal
                            :editor_first_name,#non-journal
                            :editor_last_name,#non-journal
                            :end_page,# journal
                            :isbn,#non-journal
                            :issn,# journal
                            :issue,# journal
                            :journal_title,# journal
                            :material_type,#non-journal
                            :month,# journal
                            :page_numbers,#non-journal
                            :publisher,#non-journal
                            :season,# journal
                            :start_page,# journal
                            :title,
                            :url,
                            :volume,
                            :year] # journal (also non-journal's publication year)
  attr_accessor *@@fields

  # non-persistent view of a Citation.  Type = journal, non-journal
  def initialize(attributes = {})
    puts attributes
    attributes = attributes.reduce({}){ |hash, (k, v)|
      key = k.to_s.underscore
      hash = hash.merge( key => v )  if @@fields.find_index(key.to_sym)
      hash
    }
    HashWithIndifferentAccess.new(attributes)
    attributes.each do |k,v|
      self.send (k + '=').to_sym, v  # grazie, DM
    end
    super
    raise ArgumentError.new("Citation ID can't be nil") if self.citation_id.nil?
    raise ArgumentError.new("Citation type can't be nil. CitationID: #{self.citation_id}") if self.citation_type.nil?
    raise ArgumentError.new("Citation type must be JOURNAL or NON JOURNAL. CitationID: #{self.citation_id}") if self.citation_type != "JOURNAL" && self.citation_type != "NON_JOURNAL"
    raise ArgumentError.new("Citation must have a title. CitationID: #{self.citation_id}") if self.title.nil?
  end

  def to_s
    "Citation ID: #{self.citation_id}, type: #{self.citation_type}, title: #{self.title}"
  end
end

