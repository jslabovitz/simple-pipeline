module Simple

  class Pipeline

    class Filter

      attr_accessor :input
      attr_accessor :context

      def initialize(input:, context:)
        @input = input
        @context = context
      end

      def output
        @output ||= process(@input.kind_of?(Filter) ? @input.output : @input)
      end

      def process(value)
        value
      end

    end

  end

end