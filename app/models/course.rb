# container for all the reserves for a course id
Course = Struct.new( :reserves) do
  def initialize(id)
    rep = Rlist.new.list(id)
    input_list = JSON.parse(rep.body)
    self.reserves  = input_list.collect {|request| Reserve.new(request)}
  end
  def list
    self.reserves
  end
end
