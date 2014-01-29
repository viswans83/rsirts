require "rsirts/version"
require "rsirts/parser"
require "rsirts/renderer"

module Rsirts

  def self.generate path
    Renderer.new(Parser.parse path).generate
  end
  
end
