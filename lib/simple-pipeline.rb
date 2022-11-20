require 'simple-pipeline/filter'

module Simple

  class Pipeline

    attr_accessor :context

    def initialize(filters=nil, context: nil)
      @context = context
      @filters = []
      filters.each { |f| self << f } if filters
    end

    def <<(klass)
      @filters << klass.new(input: @filters.last, context: @context)
    end

    def input=(value)
      raise "No filters" if @filters.empty?
      @filters.first.input = value
    end

    def output
      raise "No filters" if @filters.empty?
      @filters.last.output
    end

  end

end