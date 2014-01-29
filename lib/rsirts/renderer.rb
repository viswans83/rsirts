module Rsirts

  class Ring

    def initialize elements
      @elements = elements.dup
      @indx = 0
    end
    
    def add new_elements
      left = elements.take(indx)
      right = elements.drop(indx)
      self.elements = left + new_elements + right
    end

    def remove count
      from_indx = size - indx
      from_beg = count - from_indx
      if count >= from_indx
        elements.pop(from_indx)
        elements.slice!(0,from_beg) unless from_beg == 0
        self.indx = 0
      else
        elements.slice!(indx,count)
      end
    end

    def next
      result = elements[indx]
      increment_indx
      result
    end

    def size
      elements.size
    end

    private

    attr_accessor :indx, :elements
    
    def increment_indx
      self.indx = indx == (size - 1) ? 0 : indx + 1
    end
        
  end

  class Renderer

    PATTERN_CHARS = ('!'..'~').to_a
    DEFAULT_PATTERN_LENGTH = 12

    def initialize zmap_lines
      @zmap_lines = zmap_lines
      @width = zmap_lines[0].size
    end

    def generate
      zmap_lines.map do |line|
        translate_line line
      end
    end

    private

    attr_reader :zmap_lines, :width
    attr_accessor :current_line, :pattern
    
    def translate_line line
      initialize_for_new_line

      append_pattern

      old_z = nil
      line.each do |z; z_diff|
        z_diff = z - old_z if old_z
        begin
          shorten_pattern(z_diff) if z_diff > 0
          lengthen_pattern(-z_diff) if z_diff < 0
        end if z_diff
        append_pattern_char
        old_z = z
      end

      current_line
    end

    def initialize_for_new_line
      @current_line = nil.to_s
      @pattern = Ring.new(random_pattern DEFAULT_PATTERN_LENGTH)
    end

    def append_pattern
      pattern.size.times { current_line << pattern.next }
    end

    def append_pattern_char
      current_line << pattern.next
    end

    def shorten_pattern n
      pattern.remove(n)
    end

    def lengthen_pattern n
      pattern.add random_pattern(n)
    end

    def random_pattern n
      chars = PATTERN_CHARS.dup
      [].tap do |pat|
        n.times do
          item = chars.sample
          pat << item
          chars.delete_at(chars.find_index(item))
        end
      end
    end
    
  end

end
