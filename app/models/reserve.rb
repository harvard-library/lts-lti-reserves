#  reflects the Rlist "citationRequest
Reserve = Struct.new(
                     :citation_request_id, 
                     :input_citation_type, 
                     :citation, 
                     :citation_id, 
                     :contact_instructor_id, 
                     :contact_instructor_id_type, 
                     :copyright_note, 
                     :estimated_enrollment, 
                     :input_article_title, 
                     :input_author_first_name, 
                     :input_author_last_name, 
                     :input_chapter_author_first_name, #non-journal
                     :input_chapter_author_last_name, #non-journal
                     :input_chapter_title, #non-journal
                     :input_day, # journal
                     :input_doi, # journal
                     :input_edition,  #non-journal
                     :input_editor_first_name,  #non-journal
                     :input_editor_last_name,  #non-journal
                     :input_end_page, # journal
                     :input_hollis_system_number, 
                     :input_isbn, #non-journal
                     :input_issn, # journal
                     :input_issue, # journal
                     :input_journal_title, # journal
                     :input_material_type, #non-journal
                     :input_month, # journal
                     :input_page_numbers,  #non-journal
                     :input_publisher,  #non-journal
                     :input_season, # journal
                     :input_start_page, # journal
                     :input_title, 
                     :input_url, 
                     :input_volume, 
                     :input_year, # journal
                     :instance_id, 
                     :instance_id_type, 
                     :instructor_note, 
                     :instructor_sort_order, 
                     :lecture_date, 
                     :library_code, 
                     :required, 
                     :reserves_staff_note, 
                     :status, 
                     :student_annotation, 
                     :submitted_date, 
                     :submitting_system, 
                     :visibility
                      ) do
  def initialize(opts = {})
    opts = opts.reduce({}){ |hash, (k, v)| hash.merge( k.to_s.underscore => v )  }
    if opts["citation"] && opts["citation"].class.to_s == "Hash" 
        opts["citation"] = Citation.new(opts["citation"])
    end

    members =  self.members
    HashWithIndifferentAccess.new(opts)
    opts.each do |k,v|
      self.send (k + '=').to_sym, v  if members.find_index(k.to_sym)# grazie, DM
    end
    # at the present time, there's only one instructor id type
    self.contact_instructor_id_type = 'HUID'
    # a newly-created request *might* be sussed out by material type
    if self.input_citation_type.nil?
      if self.input_material_type == 'JOURNAL'
        self.input_citation_type = 'JOURNAL'
      else 
        self.input_material_type = 'NON_JOURNAL' if !self.input_material_type.nil?
      end
    end
    raise ArgumentError.new("Reserve type can't be nil") if self.input_citation_type.nil?
    raise ArgumentError.new("Reserve type must be JOURNAL or NON JOURNAL") if self.input_citation_type != "JOURNAL" && self.input_citation_type != "NON_JOURNAL"
    raise ArgumentError.new("Reserve must have a title") if self.input_title.nil?
    raise ArgumentError.new("Reserve must have an instructor ID") if self.input_title.nil?
  end
  def fill_in
    if self.citation 
      self.input_title = self.citation.title
    end
  end
end
