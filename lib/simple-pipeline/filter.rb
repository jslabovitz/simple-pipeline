module Simple

  class Pipeline

    class Filter

      attr_accessor :input
      attr_accessor :context

      def output
        value = case @input
        when Filter, Pipeline
          @input.output
        else
          @input
        end
        process(value)
      end

      def process(value)
        value
      end

    end

  end

end