# container for all the auxiliary information about the course instance
require 'icommons'
InstanceInfo = Struct.new(:id, :course_id, :title, :catalog, :term, :primary, :xreg_ids, :other_ids) do
  def initialize(id)
    self.id = id
    json = Icommons.new.course_instance(id)
    self.course_id = json["course"]["course_id"]
    compose_desc(json) # get title, catalog, term
    self.primary =  json["primary_xlist_instances"].empty? ? nil :  json["primary_xlist_instances"][0].slice(/\d\d+/).to_i
    get_xreg_ids(json["secondary_xlist_instances"])
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
    self.title = "[#{short}] #{self.title}" if short != title
  end
  def get_xreg_ids(seconds)
    ids = []
      seconds.each do |uri|
      ids.push(uri.slice(/\d\d+/))
    end
    self.xreg_ids = ids
  end

end
