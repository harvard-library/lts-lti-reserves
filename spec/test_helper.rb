module TestHelper
  def TestHelper.valid(object)
    if (!object.valid?)
      puts "\n**** #{object.errors.messages} ***\n\n"
      false
    else
      true
    end
  end
end
