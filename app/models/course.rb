# container for all the reserves for a course id
Course = Struct.new( :reserves, :id) do
# generally, we don't want to include the deletions... (Except the Librarian Request deletion)
  def initialize(id, deletes = false)
    self.id = id
    rep = Rlist.new.list(id)
    input_list = JSON.parse(rep.body)
    self.reserves  = input_list.collect {|request|  Reserve.new(request)}
    if !deletes 
        self.reserves = self.reserves.reject {|request| request.status.start_with?("DR_") }
    end
  end
  def list
    self.reserves
  end
end
