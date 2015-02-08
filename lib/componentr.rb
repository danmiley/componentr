require "componentr/version"
require 'componentr/translator'
require 'componentr/jobr'
require 'json'
require 'optparse'

module Componentr
  def self.hi(language)
    translator = Translator.new(language)
    translator.hi
  end

  def self.process(options, wargs, input)
    begin
      # do something smart with passthru
      #   return wargs, input if wargs && wargs['status'] == 'error'

      raise Exception if wargs && wargs['status'] == 'error'
      job = Jobr.new
      wargs = job.process(options, wargs, input)
      return wargs, input
    rescue Exception
      wargs['history'] = {} if ! wargs['history']
      wargs['history']["#{Time.now.to_i}#{rand}"]  = "wargs error by #{self.class}"

      return wargs, input
    end
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
      opts.on( '-a', '--wargs JSON', 'workflow arguments to be passed along (JSON.to_s arg)' ) do |json|
        options[:wargs] = json
      end

    end.parse!

    # if any commnand line args are actually prpoper named wargs, emobody themm 
    wargs = options[:wargs] rescue nil
    options.delete(:wargs)

    wargs = JSON.parse(wargs) if wargs

    # probe input to see if any wargs are in there

    input = ARGV

    inputs = input.map { |i|
      begin
        candidate = JSON.parse(i) 
        if candidate && candidate['wargs']
          # merge into wargs
          wargs.merge!(candidate)
          # if merged, we don't need this in stdin
          nil
        end
      rescue  Exception => e
        i
      end
    }.compact # get rid of nils

    $stderr.puts "inputr #{options}, #{wargs}, #{inputs}"

    # we check to see if its a wargs array, thats it
    if ! wargs
      # if we didn't get args on the command line, try file i/o,
      # this is encountered when a proc gets a pipeline input from stdout
      $stderr.puts "BIG MANGO"
#      ARGF.each do |line|
#        $stderr.puts line 
#      end
      candidate_args =  ARGF.read  rescue ''
      whatever =  ARGF.read  rescue ''
      $stderr.puts "candidate #{candidate_args}"
      $stderr.puts "whatever #{whatever}"
      candidate_json = JSON.parse(candidate_args) rescue {}
      $stderr.puts "desparate #{candidate_json}"
      wargs = candidate_json
    end

    return options, wargs, inputs
  end

  def self.outputr(wargs, output)
    $stdout.puts wargs.to_json.to_s if wargs
    output.map {|o| $stderr.puts "yup"+o
      $stdout.puts o }
  end

  def self.read_eval_print
    outputr(*process(*inputr))
  rescue Exception => e
    $stderr.puts e.message
  end

end
