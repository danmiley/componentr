require "componentr/version"
require 'componentr/translator'
require 'json'
require 'optparse'

module Componentr
  def self.hi(language)
    translator = Translator.new(language)
    translator.hi
  end
  def self.process(options, wargs, input)
    # do something smart with passthru
    $stderr.puts 'checking for status'
    return wargs, input if wargs && wargs['status'] == 'error'
    $stderr.puts 'processing'
    wargs['status'] = 'success' if wargs
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

    return options, wargs, inputs
  end

  def self.outputr(wargs, output)
    puts wargs if wargs
    output.map {|o| puts o }
  end

  def self.read_eval_print
    outputr(*process(*inputr))
  rescue Exception => e
    puts e.message
  end

end
