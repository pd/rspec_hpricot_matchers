module RspecHpricotMatchers
  class HaveTag
    def initialize(selector, inner_text_or_options, options, &block)
      @selector = selector
      if Hash === inner_text_or_options
        @inner_text = nil
        @options = inner_text_or_options
      else
        @inner_text = inner_text_or_options
        @options = options
      end
    end

    def matches?(actual, &block)
      @actual = actual
      @hdoc = hdoc_for(@actual)

      matched_elements = @hdoc.search(@selector)
      if matched_elements.empty?
        return @options[:count] == 0
      end

      if @inner_text
        matched_elements = filter_on_inner_text(matched_elements)
      end

      if block
        matched_elements = filter_on_nested_expectations(matched_elements, block)
      end

      @actual_count = matched_elements.length
      return false if not acceptable_count?(@actual_count)

      !matched_elements.empty?
    end

    def failure_message
      explanation = @actual_count ? "but found #{@actual_count}" : "but did not"
      "expected\n#{@hdoc.to_s}\nto have #{failure_count_phrase} #{failure_selector_phrase}, #{explanation}"
    end

    def negative_failure_message
      explanation = @actual_count ? "but found #{@actual_count}" : "but did"
      "expected\n#{@hdoc.to_s}\nnot to have #{failure_count_phrase} #{failure_selector_phrase}, #{explanation}"
    end

    private
      def hdoc_for(input)
        if Hpricot === input
          input
        elsif input.respond_to?(:body)
          Hpricot(input.body)
        else
          Hpricot(input.to_s)
        end
      end

      def filter_on_inner_text(elements)
        elements.select do |el|
          next(el.inner_text =~ @inner_text) if @inner_text.is_a?(Regexp)
          el.inner_text == @inner_text
        end
      end

      def filter_on_nested_expectations(elements, block)
        elements.select do |el|
          begin
            block.call(el)
          rescue Spec::Expectations::ExpectationNotMetError
            false
          else
            true
          end
        end
      end

      def acceptable_count?(actual_count)
        if @options[:count]
          return false unless @options[:count] === actual_count
        end
        if @options[:minimum]
          return false unless actual_count >= @options[:minimum]
        end
        if @options[:maximum]
          return false unless actual_count <= @options[:maximum]
        end
        true
      end

      def failure_count_phrase
        if @options[:count]
          "#{@options[:count]} elements matching"
        elsif @options[:minimum] || @options[:maximum]
          count_explanations = []
          count_explanations << "at least #{@options[:minimum]}" if @options[:minimum]
          count_explanations << "at most #{@options[:maximum]}"  if @options[:maximum]
          "#{count_explanations.join(' and ')} elements matching"
        else
          "an element matching"
        end
      end

      def failure_selector_phrase
        phrase = @selector.inspect
        phrase << (@inner_text ? " with inner text #{@inner_text.inspect}" : "")
      end
  end

  def have_tag(selector, inner_text_or_options = nil, options = {}, &block)
    HaveTag.new(selector, inner_text_or_options, options, &block)
  end
end
