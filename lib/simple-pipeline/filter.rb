module Simple

  class Pipeline

    class Filter

      attr_accessor :input
      attr_accessor :context

      def output
        @output ||= process((@input.kind_of?(Filter) || @input.kind_of?(Pipeline)) ? @input.output : @input)
      end

      def process(value)
        value
      end

    end

  end

end