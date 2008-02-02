module Diff::Display
  class Unified::Generator
    def self.run(udiff)
      raise ArgumentError, "Object must be enumerable" unless udiff.respond_to?(:each)
      generator = new
      udiff.each {|line| generator.process(line.chomp)}
      generator.data
    end
    
    def initialize
      @data = ""
    end
    
    def process(line)
      line
    end
    
    def data
      @data
    end
  end
end