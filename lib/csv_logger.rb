# Custom csv logger
class CsvLogger < Logger
  def initialize( log_file, shift_age = 0, shift_size = 10048576)
    super(nil) # this prevents it from initializing a LogDevice
    @logdev = CsvLogger::LogDevice.new(log_file, shift_age: shift_age, shift_size: shift_size)
    self.formatter = formatter
    self
  end
 # Optional, but good for prefixing timestamps automatically
  def formatter
    Proc.new{|severity, time,progname,  msg|
      formatted_time = time.strftime("%Y-%m-%d,%H:%M:%S")
      "#{formatted_time},#{msg.to_s.strip}\n"
    }
  end


  class LogDevice < ::Logger::LogDevice
    def add_log_header(file) 
      file.write("Date,Time,IP Address, Course Instance ID, Reserve ID, Action\n")# if file.size = 0
    end
    

  end
end
