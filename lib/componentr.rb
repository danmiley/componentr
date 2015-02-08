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
end
