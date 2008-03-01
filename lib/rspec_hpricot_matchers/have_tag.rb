module RspecHpricotMatchers
  class HaveTag
    def initialize(selector, inner_text, &block)
      @selector = selector
      @inner_text = inner_text
    end

    def matches?(actual)
      @actual = actual
      @hdoc = case @actual
              when String then Hpricot(@actual)
              when Hpricot then @actual
              end

      matched_elements = (@hdoc / @selector)
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
          rescue
            false
          else
            true
          end
        end
      end

      !matched_elements.empty?
    end

    def failure_message
      with_inner_text = @inner_text ? " with inner text #{@inner_text.inspect}" : ""
      "expected #{@actual.inspect} to have tag #{@selector.inspect}#{with_inner_text}, but did not"
    end

    def negative_failure_message
      with_inner_text = @inner_text ? " with inner text #{@inner_text.inspect}" : ""
      "did not expect #{@actual.inspect} to have tag #{@selector.inspect}#{with_inner_text}, but did"
    end
  end

  def have_tag(selector, inner_text = nil, &block)
    HaveTag.new(selector, inner_text, &block)
  end
end
