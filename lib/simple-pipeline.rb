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

    def process(value)
      if @filters.empty?
        value
      else
        @filters.first.input = value
        @filters.last.result
      end
    end

  end

end