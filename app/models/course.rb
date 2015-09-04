# container for all the reserves for a course id
Course = Struct.new( :reserves, :id) do
# generally, we don't want to include the deletions... (Except the Librarian Request deletion)
  def initialize(id)
    self.id = id
    rep = Rlist.new.list(id)
    input_list = JSON.parse(rep.body)
    self.reserves  = input_list.collect {|request|  Reserve.new(request)}
  end
  def list
    if self.reserves.any?{ |res| !res.instructor_sort_order.nil? }
      self.reserves.sort_by! {|res| res.instructor_sort_order.to_i || 0 }
    end
    self.reserves
  end
  def student_list
    no_deletes
    visible_only
    no_new
    self.reserves
  end
  def no_deletes
       self.reserves = self.reserves.reject {|request| request.status.start_with?("DR_") }
  end
  def visible_only
    self.reserves = self.reserves.reject {|request| request.visibility == "R" }
  end
  def no_new
    self.reserves = self.reserves.reject {|request| request.display_status == "New" }
  end
end
