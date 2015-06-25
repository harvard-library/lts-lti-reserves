# opts conversion thanks to http://chrisholtz.com/blog/lets-make-a-ruby-hash-map-method-that-returns-a-hash-instead-of-an-array/
Citation = Struct.new(:citation_id,
                            :citation_type, # either JOURNAL or NON_JOURNAL
                            :aleph_url,
                            :author_first,
                            :author_last,
                            :chapter_author_first,#non-journal
                            :chapter_author_last,#non-journal
                            :chapter_title,#non-journal
                            :day,# journal
                            :doi,# journal
                            :edition,#non-journal
                            :editor_first,#non-journal
                            :editor_last,#non-journal
                            :end_page,# journal
                            :isbn,#non-journal
                            :issn,# journal
                            :issue,# journal
                            :journal_title,# journal
                            :material_type,#non-journal
                            :month,# journal
                            :page_numbers,#non-journal
                            :publication_year,#non-journal
                            :publisher,#non-journal
                            :season,# journal
                            :start_page,# journal
                            :title,
                            :url,
                            :volume,
                            :year # journal
                            ) do
  # non-persistent view of a Citation.  Type = journal, non-journal
  def initialize(opts = {})
#    endit = opts.reduce({}){ |hash, (k, v)| hash.merge( k.to_s.camelize => v )  }
    opts = opts.reduce({}){ |hash, (k, v)| hash.merge( k.to_s.underscore => v )  }
#    puts opts
    members =  self.members
    HashWithIndifferentAccess.new(opts)
    opts.each do |k,v|
      self.send (k + '=').to_sym, v  if members.find_index(k.to_sym)# grazie, DM
    end
    raise ArgumentError.new("Citation ID can't be nil") if self.citation_id.nil?
    raise ArgumentError.new("Citation type can't be nil") if self.citation_type.nil?
    raise ArgumentError.new("Citation type must be JOURNAL or NON JOURNAL") if self.citation_type != "JOURNAL" && self.citation_type != "NON_JOURNAL"
    raise ArgumentError.new("Citation must have a title") if self.title.nil?
  end
  def to_s
    "Citation ID: #{self.citation_id}, type: #{self.citation_type}, title: #{self.title}"
  end
end
#  cit = Citation.new({:citation_id => "2", :citation_type => "JOURNAL"})
#  cit = Citation.new("2", "JOURNAL")
#  puts cit.to_s

