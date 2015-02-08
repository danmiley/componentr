require "componentr/version"
require 'componentr/translator'
require 'json'

module Componentr
  def self.hi(language)
    translator = Translator.new(language)
    translator.hi
  end
  def self.process(options, wargs, input)
      $stderr.puts "#{options.to_s}  and #{wargs} and #{input}" if options[:passthru] == true
      wargs['status'] = 'success'
      return wargs, input
  end


  def self.inputr
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: coomponentr [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
  opts.on("-p", "--[no-]passthru", "Passthru Arguments") do |p|
    options[:passthru] = p
  end

  options[:wargs] = nil 
  opts.on( '-a', '--wargs JSON', 'Write log to FILE' ) do |json|
    options[:wargs] = json
  end

end.parse!

# if any commnand line args are actually prpoper named wargs, emobody themm 
$stderr.puts "RAWR : optionss #{options}"
wargs = options[:wargs] rescue nil
options.delete(:wargs)

wargs = JSON.parse(wargs) if wargs
$stderr.puts "RAWR: bJSONIc goodies are #{wargs}, right"

# probe input to see if any wargs are in there

#p ARGV
input = ARGV

net_input = input.map { |i|
  begin
    candidate = JSON.parse(i) 
      $stderr.puts "candidate #{candidate} "
        $stderr.puts "subcandidate #{candidate['wargs']} " rescue nil
    if candidate && candidate['wargs']
      $stderr.puts "got one #{candidate}"
      # merge into wargs
      candidate.delete('wargs')

      wargs.merge!(candidate)
      # if merged, we don't need this in stdin
      nil
    end
  rescue  Exception => e
    i
  end

  }.compact # get rid of nils

      return options, wargs, net_input
  end

end
