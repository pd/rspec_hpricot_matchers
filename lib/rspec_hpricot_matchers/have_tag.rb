module RspecHpricotMatchers
  class HaveTag
    def initialize(selector, inner_text)
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
      return true unless @inner_text

      matched_elements.any? do |e|
        case @inner_text
        when Regexp
          e.inner_text =~ @inner_text
        else
          e.inner_text == @inner_text
        end
      end
    end

    def failure_message
      with_inner_text = @inner_text ? " with inner text #{@inner_text.inspect}" : ""
      "expected #{@actual.inspect} to have tag #{@selector.inspect}#{with_inner_text}, but did not"
    end

    def negative_failure_message
      "did not expect #{@actual.inspect} to have tag #{@selector.inspect}#{with_inner_text}, but did"
    end
  end

  def have_tag(selector, inner_text = nil)
    HaveTag.new(selector, inner_text)
  end
end
