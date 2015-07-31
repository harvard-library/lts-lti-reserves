class Reserve
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Validations
  extend ActiveModel::Callbacks
  define_model_callbacks :create, :update
  EDIT_FIELDS = [  {"estimated_enrollment" => "Estimated Number of Enrolled Students"},
                   {"lecture_date" => "Lecture/Class Date", "type" => "date"},
                   {"visibility" => "Display to Students", "type" => "boolean"},
                   {"required" => "Required Reading", "type" => "boolean"},
                   {"student_annotation" => "Note to Student", "type" => "text"}
                ]
  NEW_FIELDS = [   {"library_code" => "Library", "type" => "lib"},
                   {"input_material_type" => "Material type", "type" => "list"},
                   {"estimated_enrollment" => "Estimated Number of Enrolled Students"},
                   {"lecture_date" => "Lecture/Class Date", "type" => "date"},
                   {"visibility" => "Display to Students", "type" => "boolean"},
                   {"required" => "Required Reading", "type" => "boolean"},
                   {"input_hollis_system_number" => "HOLLIS number", "journal" => false},
                   {"input_title" => "Title or Description", "journal" => false},
                   {"input_author_last_name" => "Author Last"},
                   {"input_author_first_name" => "Author First"},
                   {"input_article_title" => "Article Title", "journal" => true, "required" => true},
                   {"input_doi" => "DOI (Digital Object Identifier)/PUBMED ID",  "journal" => true },
                   {"input_journal_title" => "Journal Title",  "journal" => true, "required" => true},
                   {"input_editor_last_name" => "Editor's Last Name"},
                   {"input_editor_first_name" => "Editor's First Name"},
                   {"input_publisher" => "publisher", "journal" => false},
                   {"input_year" => "Year of Publication", "journal" => false},
                   {"input_chapter_author_last_name" => "Last Name of Chapter/Excerpt Author", "journal" => false},
                   {"input_chapter_author_first_name" => "First Name of Chapter/Excerpt Author", "journal" => false},
                   {"input_chapter_title" => "Chapter Title", "journal" => false},
                   {"input_page_numbers" => "Page Numbers", "journal" => false},
                   {"input_edition" => "Edition", "journal" => false},
                   {"input_year" => "Year", "journal" => true},
                   {"input_season" => "Season",  "journal" => true},
                   {"input_month" => "Month",  "journal" => true},
                   {"input_day"=> "Day",  "journal" => true},
                   {"input_volume" => "Volume",  "journal" => true},
                   {"input_issue" => "Issue/Number",  "journal" => true},
                   {"input_start_page" => "Start Page",  "journal" => true},
                   {"input_end_page" => "End Page",  "journal" => true},
                   {"input_issn" => "ISSN",  "journal" => true},
                   {"input_url" => "URL"},
                   {"instructor_note" => "Note to Reserves Staff", "type" => "text" },
                   {"student_annotation" => "Note to Students", "type" => "text" }
                  ]

  @@fields  =        [ :citation_request_id, 
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
                     :input_publisher,  #non-journal
                     :input_season, # journal
                     :input_start_page, # journal
                     :input_title, 
                     :input_url, 
                     :input_volume, 
                     :input_year, # journal; this also serves as non-journal "publication_year"
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
                     :visibility ]
  attr_accessor *@@fields

  validates_numericality_of :estimated_enrollment, allow_nil: true
  validates_inclusion_of :input_citation_type, :in => %w(JOURNAL NON_JOURNAL), :message => "Reserve type must be JOURNAL or NON JOURNAL"
  validates_presence_of :contact_instructor_id, :message => "Reserve must have an instructor ID"
  validates_presence_of :instance_id, :message => "Reserve must have an associated course instance id"
  validate :has_minimal_input

  def has_minimal_input
    if !self.citation_id
      if self.input_citation_type == "JOURNAL"
        errors.add(:base,"Journal Reserve minimum: Article Title AND Journal Title OR URL") if self.input_url.nil? && (self.input_title.nil?  || self.input_journal_title.nil?)
      elsif self.input_citation_type == "NON-JOURNAL"
        errors.add(:base,"Non-journal Reserve minimum: HOLLIS number OR Title OR URL") if (self.input_hollis_system_number.nil? && self.input_title.nil? && self.input_url.nil?)
      end
    end
  end
                    
  def initialize(attributes = {})
    attributes = attributes.reduce({}){ |hash, (k, v)| 
     key = k.to_s.underscore
      hash = hash.merge( key => v )  if @@fields.find_index(key.to_sym)
      hash
    }
    if attributes["citation"] && attributes["citation"].class.to_s == "Hash" 
        attributes["citation"] = Citation.new(attributes["citation"])
    end
    HashWithIndifferentAccess.new(attributes)
    attributes.each do |k,v|
      self.send (k + '=').to_sym, v  # grazie, DM
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
    super
  end
  def create
    run_callbacks :create do
      puts "CREATE ACTION METHODS "
    end
  end
  # returns nil or the Library object
  def library
      library = Library::fetch_library(self.library_code)
  end
  def update
    run_callbacks :update do
      puts "UPDATE ACTION METHODS"
    end
  end
  def to_param
    self.citation_request_id.to_s
  end
  def persisted?
    self.citation_request_id.present?
  end
  def id  # need this for modelling?
    self.citation_request_id
  end
  def fill_in
#    puts "fill_in #{self.citation}"
    if self.citation 
      members = self.methods
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
  def year
    if self.citation
      self.citation.year
    else
      self.input_year
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
