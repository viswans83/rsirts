module Rsirts
  
  class ParseError < StandardError; end

  class Parser

    ZMAP_VALUES = Hash[ "12345689-".each_char.to_a.map { |v| [v, v == '-' ? 0 : v.to_i] } ]

    def self.parse path
      new.parse path
    end
    
    def parse path
      map_depth(
        File.new(path)
        .readlines
        .map { |line| line.chomp }
        .tap { |lines| check_format lines }
      )
    end

    private
    
    def check_format lines
      lines.each_with_index do |line,i|
        line_length ||= line.length
        raise ParseError, "Length of line #{i+1} does not match previous lines" if line.length != line_length
        raise ParseError, "Invalid character at line #{i+1} position #{$~.offset(0)[0]}" if line[/[^-0-9]/]
      end
    end

    def map_depth lines
      lines.map do |line|
        line.each_char.to_a.map do |c|
          ZMAP_VALUES[c]
        end
      end
    end

  end

end

