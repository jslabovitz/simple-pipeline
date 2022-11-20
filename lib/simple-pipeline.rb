require 'simple-pipeline/filter'

module Simple

  class Pipeline

    def initialize(filters=nil, context: nil)
      @context = context
      @filters = []
      filters.each { |f| self << f } if filters
    end

    def <<(klass)
      @filters << klass.new(input: @filters.last, context: @context)
    end

    def input=(value)
      @filters.first.input = value
    end

    def output
      @filters.last.output
    end

  end

end