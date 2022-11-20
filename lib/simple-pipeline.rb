require 'simple-pipeline/filter'

module Simple

  class Pipeline

    attr_accessor :context

    def initialize(filters=nil, context: nil)
      @context = context
      @filters = []
      filters.each { |f| self << f } if filters
    end

    def <<(obj)
      filter = case obj
      when Class
        obj.new
      when Filter
        obj
      when Pipeline
        obj
      else
        raise
      end
      filter.input = @filters.last
      filter.context = @context
      @filters << filter
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