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

    def matches?(actual)
      @actual = actual
      @hdoc = if Hpricot === @actual
                @actual
              elsif @actual.respond_to?(:body)
                Hpricot(@actual.body)
              else
                Hpricot(@actual.to_s)
              end

      matched_elements = @hdoc.search(@selector)
      return false if matched_elements.empty?

      if @inner_text
        matched_elements = matched_elements.select do |e|
          case @inner_text
          when Regexp
            e.inner_text =~ @inner_text
          else
            e.inner_text == @inner_text
          end
        end
      end

      if block_given?
        matched_elements = matched_elements.select do |e|
          begin
            yield e
          rescue Spec::Expectations::ExpectationNotMetError
            false
          else
            true
          end
        end
      end

      @actual_count = matched_elements.length
      if @options[:count]
        return false unless @options[:count] === matched_elements.length
      end
      if @options[:minimum]
        return false unless matched_elements.length >= @options[:minimum]
      end
      if @options[:maximum]
        return false unless matched_elements.length <= @options[:maximum]
      end

      !matched_elements.empty?
    end

    def failure_message
      with_inner_text   = @inner_text ? " with inner text #{@inner_text.inspect}" : ""
      explanation       = @actual_count ? "but found #{@actual_count}" : "but did not"
      count_explanation = @options[:count] ? "#{@options[:count]} elements matching" : "an element matching"
      "expected\n#{@hdoc.to_s}\nto have #{count_explanation} #{@selector.inspect}#{with_inner_text}, #{explanation}"
    end

    def negative_failure_message
      with_inner_text = @inner_text ? " with inner text #{@inner_text.inspect}" : ""
      explanation     = @actual_count ? "but found #{@actual_count}" : "but did"
      count_explanation = @options[:count] ? "#{@options[:count]} elements matching" : "an element matching"
      "did not expect\n#{@hdoc.to_s}\nto have #{count_explanation} #{@selector.inspect}#{with_inner_text}, #{explanation}"
    end
  end

  def have_tag(selector, inner_text_or_options = nil, options = {}, &block)
    HaveTag.new(selector, inner_text_or_options, options, &block)
  end
end
