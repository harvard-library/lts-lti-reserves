def fetch_list
  begin
    resp = Rlist.new.library_list
    #puts resp
    list = JSON.parse(resp.body)
    list.collect {|lib| Library.new(lib)}
  end
rescue Exception => bang
 raise "Unable to retrieve information on Libraries : #{bang}"
end
puts "Fetching Libraries list"
Library::LIBRARY_LIST = fetch_list
puts "Fetched #{Library::LIBRARY_LIST.count} Libraries"
