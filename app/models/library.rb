# a library object
Library = Struct.new(:library_code, :name, :contact_email, :support_url) do
  $library_list = []
  def self.fetch_library(code)
    list = self.library_list
    list.detect {|lib| lib.library_code == code}
  end
 
  def self.library_list
    if $library_list.count == 0 
      begin
        resp = Rlist.new.library_list
        list = JSON.parse(resp.body)
        $library_list = list.collect {|lib| Library.new(lib)}
        puts "Fetched #{$library_list.count} Libraries"
      end
    end
    $library_list
  rescue Exception => bang
    warn  "Unable to retrieve information on Libraries : #{bang}"
    $library_list
  end
  def self.library_options
    options = []
    self.library_list.each do |l|
      options.push([l.name, l.library_code])
    end
    options
  end
  def initialize(opts = {})
    opts = opts.reduce({}){ |hash, (k, v)| hash.merge( k.to_s.underscore => v )  }
    members =  self.members
    HashWithIndifferentAccess.new(opts)
    opts.each do |k,v|
      self.send (k + '=').to_sym, v  if members.find_index(k.to_sym)
    end
  end
end
