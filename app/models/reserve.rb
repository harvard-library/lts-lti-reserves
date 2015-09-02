class Reserve
  include ActiveModel::Model
  include ActiveModel::Serialization
  include ActiveModel::Validations
  extend ActiveModel::Callbacks
  define_model_callbacks :create, :update
  MATERIAL_TYPES = ["Book","Journal Article", "Video", "Audio", "Image", "Map", "Score", "Other"]
  EDIT_FIELDS = [  { "name" => "estimated_enrollment", "label" => "Estimated Number of Enrolled Students"},
                   { "name" => "lecture_date", "label" => "Lecture/Class Date", "type" => "date"},
                   { "name" => "visibility", "label" => "Display to Students", "type" => "boolean"},
                   { "name" => "required", "label" => "Required Reading", "type" => "boolean"},
                   { "name" => "student_annotation", "label" => "Note to Student", "type" => "text"}
                ]
  NEW_FIELDS = [   # also EDIT_FIELDS, ABOVE AND     {"instructor_note" => {"label" => "Note to Reserves Staff", "type" => "text" }},
                { "name" => "hollis_system_number", "label" =>"HOLLIS number", "journal" => false},
                { "name" => "title", "label" => "Title or Description", "journal" => false},
                { "name" => "author_last_name", "label" => "Author Last"},
                { "name" => "author_first_name", "label" =>  "Author First"},
                { "name" => "article_title", "label" => "Article Title", "journal" => true, "required" => true},
                { "name" => "journal_title", "label" => "Journal Title",  "journal" => true, "required" => true},
                { "name" => "doi", "label" => "DOI (Digital Object Identifier)/PUBMED ID",  "journal" => true },
                { "name" => "url", "label" => "URL"},
                { "name" => "editor_last_name", "label" => "Editor's Last Name"},
                { "name" => "editor_first_name", "label" => "Editor's First Name"},
                { "name" => "publisher", "label" => "Publisher", "journal" => false},
                { "name" => "year", "label" => "Year of Publication", "journal" => false},
                { "name" => "chapter_author_last_name", "label" =>  "Last Name of Chapter/Excerpt Author", "journal" => false},
                { "name" => "chapter_author_first_name", "label" => "First Name of Chapter/Excerpt Author", "journal" => false},
                { "name" => "chapter_title", "label" => "Chapter Title", "journal" => false},
                { "name" => "page_numbers", "label" => "Page Numbers", "journal" => false},
                { "name" => "edition", "label" => "Edition", "journal" => false},
                { "name" => "year", "label" => "Year",  "journal" => true},
                { "name" => "season", "label" => "Season",  "journal" => true},
                { "name" => "month", "label" => "Month",  "journal" => true},
                { "name" => "day", "label" => "Day",  "journal" => true},
                { "name" => "volume", "label" => "Volume",  "journal" => true},
                { "name" => "issue", "label" => "Issue/Number",  "journal" => true},
                { "name" => "start_page", "label" => "Start Page",  "journal" => true},
                { "name" => "end_page", "label" => "End Page",  "journal" => true},
                { "name" => "issn", "label" => "ISSN",  "journal" => true}
              ]

  FIELDS  =        [ :citation_request_id, 
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
  attr_accessor *FIELDS

#  validates_numericality_of :estimated_enrollment, allow_nil: true, only_integer: true
  validate :has_citation_type
  validates_presence_of :contact_instructor_id, :message => "Reserve must have an instructor ID"
  validates_presence_of :instance_id, :message => "Reserve must have an associated course instance id"
  validates_presence_of :library_code, :message => "Please identify a library"
  
  validate :has_minimal_input
  
# validation methods
  def has_citation_type
    if self.citation_id.blank? && (self.input_citation_type.nil? || %w(JOURNAL NON_JOURNAL).find_index(self.input_citation_type).nil?)
      message = "Please specify a material type"
      errors.add(:base, message)
    end
  end
  def has_minimal_input
    if self.citation_id.blank?
      if self.input_citation_type == "JOURNAL" && self.input_url.blank? && (self.input_title.blank?  || self.input_journal_title.blank? )
        msg = "Journal Reserve minimum: Article Title AND Journal Title OR URL"
        errors.add(:base,msg)
        [:input_url, :input_title, :input_journal_title].each { |f| errors.add(f,msg) if self.send(f).blank? }
      elsif self.input_citation_type == "NON_JOURNAL" && self.input_hollis_system_number.blank? && self.input_title.blank? && self.input_url.blank?
        msg = "Non-journal Reserve minimum: HOLLIS number OR Title OR URL"
        errors.add(:base, msg)
        [:input_hollis_system_number, :input_title, :input_url].each  { |f| errors.add(f,msg) if self.send(f).blank? }
        end
    end
  end

  def self.material_types
    return MATERIAL_TYPES
  end
  def initialize(attributes = {})
    attributes = attributes.reduce({}){ |hash, (k, v)| 
     key = k.to_s.underscore
      hash = hash.merge( key => v )  if FIELDS.find_index(key.to_sym)
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
    # enrollment issues
    self.estimated_enrollment = "0" if self.estimated_enrollment.blank?
    # a newly-created request *might* be sussed out by material type
    if self.input_citation_type.blank? && !self.input_material_type.blank? 
      if self.input_material_type.upcase.start_with?('JOURNAL')
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
      self.citation.fields.each do |name|
        if name.to_s != 'citation_type'
          value = self.citation.send(name)
          if value 
            k = 'input_' + name.to_s
#            puts "#{(k + '=')} should have #{value} with class #{value.class} in members: #{ members.find_index(k.to_sym)}"
            self.send (k + '=' ).to_sym, value.strip if members.find_index(k.to_sym)
          end
        end
      end
    end
  end
  def author
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
    if self.citation
      lastn = self.citation.editor_last_name 
      first = self.citation.editor_first_name
    else
      lastn = self.input_editor_last_name
      first = self.input_editor_first_name
    end
    normalize_name(lastn, first)

  end
  # volume, number, date, etc.
  def journal_info
    if self.citation
      vol = self.citation.volume
      issue = self.citation.issue
      season = self.citation.season
      day = self.citation.day
      month = self.citation.month
      yr = self.citation.year
      startp = self.citation.start_page
      endp = self.citation.end_page
  else
     vol = self.input_volume
      issue = self.input_issue
      season = self.input_season
      day = self.input_day
      month = self.input_month
      yr = self.input_year
      startp = self.input_start_page
      endp = self.input_end_page
    end
    vol_str = ""
    vol_str = "vol. #{vol}" if vol
    vol_str = "#{vol_str} no.#{issue}" if issue
    date = season || ""
    if date = ""
      date = "#{date} #{day}" if day
      date = "#{date} #{month}" if month
      date = "#{date} #{year}" if year
    end
    pp = startp || ""
    pp = "#{pp} #{endp}" if endp
    pp = "pp. #{pp}"
    "#{vol_str} (#{date.strip}) #{pp}".strip
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
    if lastn
      if first
        lastn = lastn + ", " + first
      end
      lastn = lastn + "." if !lastn.ends_with?(".")
    end
    lastn
  end
end
