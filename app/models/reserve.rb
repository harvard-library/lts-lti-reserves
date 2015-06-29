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
    # only instances are Course instances
    self.instance_id_type = 'COURSE'
    # a newly-created request *might* be sussed out by material type
    if self.input_citation_type.nil? && self.input_material_type
      if self.input_material_type.upcase == 'JOURNAL'
        self.input_citation_type = 'JOURNAL'
      else  self.input_material_type
        self.input_citation_type = 'NON_JOURNAL' 
      end
    end
    #fill_in
    raise ArgumentError.new("Reserve type can't be nil") if self.input_citation_type.nil?
    raise ArgumentError.new("Reserve type must be JOURNAL or NON JOURNAL") if self.input_citation_type != "JOURNAL" && self.input_citation_type != "NON_JOURNAL"
    raise ArgumentError.new("Reserve must have a either a title or url ") if self.citation.nil? && self.input_title.nil? && self.input_url.nil?
    raise ArgumentError.new("Reserve must have an instructor ID") if self.contact_instructor_id.nil?
    raise  ArgumentError.new("Reserve must have an associated course instance id") if self.instance_id.nil?
    raise ArgumentError.new("Reserve must have a material type") if  self.citation.nil? && self.input_material_type.nil? && self.input_citation_type.nil?
  end
  def fill_in
#    puts "fill_in #{self.citation}"
    if self.citation 
      members = self.members
      self.citation.each_pair { |name, value|
        if value && name.to_s != 'citation_type'
          k = 'input_' + name.to_s
          puts "#{(k + '=')} should have #{value} with class #{value.class} in members: #{ members.find_index(k.to_sym)}"
          self.send (k + '=' ).to_sym value if members.find_index(k.to_sym)
        end
      }
    end
  end
  def author
    last = "";
    if self.citation
      lastn = self.citation.author_last_name
      first = self.citation.author_first_name
    else
      lastn = self.input_author_last_name
      first = self.input_author_first_name
    end
    if first
      lastn = lastn + ", " + first
    end
    if lastn
      lastn = lastn + "." if !lastn.ends_with?(".")
    end
    lastn
  end
  def title
    if self.citation
      self.citation.title
    else
      self.input_title
    end
  end
  def dig_url
    if self.citation
      self.citation.url if self.citation.url
    else
      self.input_url
    end
  end
end
