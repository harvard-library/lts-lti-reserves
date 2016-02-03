# container for all the auxiliary information about the course instance
require 'icommons'
require 'timeout'
InstanceInfo = Struct.new(:id, :non_enroll, :course_id, :title, :catalog, :term, :primary, :xreg_ids, :others) do
  def initialize(id_or_url)
    json = Icommons.new.course_instance(id_or_url)
    if !json.empty? 
      self.id = json["course_instance_id"]
      self.course_id = json["course"]["course_id"]
      self.non_enroll = json["exclude_from_isites"] != "0"
      compose_desc(json) # get title, catalog, term
      self.primary =  json["primary_xlist_instances"].empty? ? nil :  json["primary_xlist_instances"][0]
      self.xreg_ids = json["secondary_xlist_instances"]
    end
  end

  def fill_primary
    if self.primary && self.primary.starts_with?("https:")
      ii = InstanceInfo.new(self.primary)
      self.primary = ii if !ii.non_enroll
    end
  end
  def fill_others
    others = []
    begin status = Timeout::timeout(11) {
        others = Rlist.new.previous(self.id)
      }
    rescue Timeout::Error
      STDERR.puts "TIMEDOUT ON COURSE #{self.id} "
      raise
    ensure
      self.others = others
    end
  end
  def compose_desc(json)
    school = json["term"]["school_id"].upcase!
    school = "FAS" if school == "COLGSAS"
    self.catalog = "#{school}-#{json['course']['registrar_code_display']}"
    self.term = json["term"]["display_name"]
    title = json["title"] 
    sub = json["sub_title"]
    self.title = title
    self.title = "#{self.title}: #{sub}" if !sub.blank? && title != sub
    short = json["short_title"]
    self.title = "[#{short}] #{self.title}" if !short.blank? && short != title
  end

end
