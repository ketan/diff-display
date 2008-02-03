module Diff::Display
  # Processes the diff and generates a Data object which contains the
  # resulting data structure.
  #
  # The +run+ class method is fed a diff and returns a Data object. It will
  # accept as its argument a String, an Array or a File object (or anything 
  # that responds to #each):
  #
  #   Diff::Display::Unified::Generator.run(diff)
  #
  class Unified::Generator
    
    # Extracts the line number info for a given diff section
    LINE_NUM_RE = /@@ [+-]([0-9]+),([0-9]+) [+-]([0-9]+),([0-9]+) @@/
    LINE_TYPES  = {'+' => :add, '-' => :rem, ' ' => :unmod}
    
    # Runs the generator on a diff and returns a Data object
    def self.run(udiff)
      raise ArgumentError, "Object must be enumerable" unless udiff.respond_to?(:each)
      generator = new
      udiff.each {|line| generator.process(line.chomp)}
      generator.data
    end
    
    def initialize
      @buffer         = []
      @prev_buffer    = []
      @line_type      = nil
      @prev_line_type = nil
      @offset_base    = 0
      @offset_changed = 0
      @data = Data.new
      self
    end
    
    def data
      @data
    end
    
    # Operates on a single line from the diff and passes along the
    # collected data to the appropriate method for further processing. The
    # cycle of processing is in general:
    #
    #   process --> identify_block --> process_block --> process_line 
    #    
    def process(line)
      if is_header_line?(line)
        # TODO: add to HeaderBlock or something
        return
      end
      
      if line =~ LINE_NUM_RE
        identify_block
        add_separator unless @offset_changed.zero?
        @line_type      = nil
        @offset_base    = $1.to_i - 1
        @offset_changed = $3.to_i - 1
        return
      end
      
      new_line_type, line = LINE_TYPES[car(line)], cdr(line)
    end
    
    protected
      def is_header_line?(line)
        return true if ['++', '--'].include?(line[0,2])
        return true if line =~ /^(new|delete) file mode [0-9]+$/
        return true if line =~ /^diff \-\-git/
        return true if line =~ /^index \w+\.\.\w+ [0-9]+$/
        false
      end
      
      def identify_block
        
      end
      
      def car(line)
        line[0,1]
      end

      def cdr(line)
        line[1..-1]
      end
  end
end