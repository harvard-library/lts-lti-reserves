# a library object
Library = Struct.new(:library_code, :name, :contact_email, :support_url) do
  def initialize(opts = {})
    opts = opts.reduce({}){ |hash, (k, v)| hash.merge( k.to_s.underscore => v )  }
    members =  self.members
    HashWithIndifferentAccess.new(opts)
    opts.each do |k,v|
      self.send (k + '=').to_sym, v  if members.find_index(k.to_sym)
    end
  end
end
