class Reserve
  include ActiveModel::Model

  attr_accessor     :citation_request_id, 
                     :input_citation_type, 
                     :citation, 
                     :citation_id, 
                     :contact_instructor_id, 
                     :contact_instructor_id_type, 
                     :copyright_note, 
                     :course_status,
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
                     :input_publication_year, #non-journal
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
                    
  def initialize(opts = {})
    opts = opts.reduce({}){ |hash, (k, v)| hash.merge( k.to_s.underscore => v )  }
    if opts["citation"] && opts["citation"].class.to_s == "Hash" 
        opts["citation"] = Citation.new(opts["citation"])
    end

    members =  self.methods
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
          self.send (k + '=' ).to_sym value.strip if members.find_index(k.to_sym)
        end
      }
    end
  end
  def author
    lastn = ""
    if self.citation
      lastn = self.citation.author_last_name 
      first = self.citation.author_first_name
    else
      lastn = self.input_author_last_name
      first = self.input_author_first_name
    end
    normalize_name(lastn, first)
  end
  def editor
    lastn = ""
    if self.citation
      lastn = self.citation.editor_last_name
      first = self.citation.editor_first_name
    else
      lastn = self.input_editor_last_name
      first = self.input_editor_first_name
    end
    normalize_name(lastn, first)

  end
  def title
    if self.citation && self.citation.title
      self.citation.title
    else
      self.input_title
    end
  end
  def journal_title
    if self.citation
      self.citation.journal_title
    else
      self.input_journal_title
    end
  end
  def dig_url
    if self.citation
      self.citation.url if self.citation.url
    else
      self.input_url
    end
  end
  def chapter_title
    if self.citation && self.citation.chapter_title
      self.citation.chapter_title
    else
      self.input_chapter_title
    end
  end
  def chapter_author
    lastn = ""
    if self.citation && self.citation.chapter_author_last_name
      lastn = self.citation.chapter_author_last_name
      first = self.citation.chapter_author_first_name || self.input_.chapter_author_first_name
    else
      lastn = self.input_chapter_author_last_name
      first = self.input_chapter_author_first_name
    end
    normalize_name(lastn, first)
  end
  def edition
    if self.citation && self.citation.edition
      self.citation.edition
    else
      self.input_edition
    end
  end
  def isbn
    if self.citation
      self.citation.isbn
    else
      self.input_isbn
    end
  end
  def volume
    if self.citation
      self.citation.volume
    else
      self.input_volume
    end
  end
  def page_numbers
    if self.citation
      self.citation.page_numbers
    else
      self.input_page_numbers
    end
  end
  def publisher
    if self.citation
      self.citation.publisher
    else
      self.input_publisher
    end
  end

  def publication_year
    if self.citation
      self.citation.publication_year
    else
      self.input_publication_year
    end
  end


  def hollis_system_number
   if self.citation
      self.citation.hollis_system_number
    else
      self.input_hollis_system_number
    end
  end
  def chapter?
    self.chapter_title || self.chapter_author
  end
  def tip_title
    # what's used in tool tips
    self.chapter_title || self.title
  end
  def journal_title
    if self.citation && self.citation.journal_title
      self.citation.journal_title
    else
      self.input_journal_title
    end
  end
  def journal?
    type = self.citation ? self.citation.citation_type : self.input_citation_type
    !type.nil? && type == 'JOURNAL'
  end
  def display_status
    if self.course_status.nil?
      # no course_status
      if self.status.nil?
        "Unknown"
      else 
        case self.status
        when "COMPLETE" then "Available"
        when "COMPLETE_PARTIAL" then "Partially Available"
        when "NEW" then "New"
        when "DRL_LIB_REQUEST" then "Librarian Requested Deletion"
        else "In Process"
        end
      end
    else
    # we have course_status
      if self.course_status.upcase.start_with?("COMPLETE") then "Available"
      else self.course_status
      end
    end
  end
  def normalize_name(lastn, first)
    if first
      lastn = lastn + ", " + first
    end
    if lastn
      lastn = lastn + "." if !lastn.ends_with?(".")
    end
    lastn
  end
end
