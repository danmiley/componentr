class Componentr::Jobr
  def initialize

  end

  def process(options, wargs, input)
    begin
    wargs['history'] = {} if ! wargs['history']
    wargs['history']["#{Time.now.to_i}#{rand}"]  = "processed by #{self.class}"
    wargs['status'] = 'success' if wargs
    wargs
    rescue Exception => e
      $stderr.puts "run.process" + e.inspect
    end
  end
end
