require "componentr/version"
require 'componentr/translator'

module Componentr
  def self.hi(language)
    translator = Translator.new(language)
    translator.hi
  end
end
