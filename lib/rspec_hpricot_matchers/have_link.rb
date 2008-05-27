module RspecHpricotMatchers
  class HaveLink
    def initialize(example, url, options={})
      template = example.template
      @options = options
      link = Hpricot(template.link_to('ignore-me', url, options)).at('/')
      @expected_onclick = link[:onclick]
      @expected_href = link[:href]
    end

    def matches?(doc, &block)
      @doc = doc
      if @expected_onclick
        @doc.search("a[@href=#{@expected_href}]").any? do |link|
          link[:onclick] == @expected_onclick
        end
      else
        @doc.at("a[@href=#{@expected_href}]")
      end
    end

    def failure_message
      [
        "expected #{@doc.inner_html.inspect}",
        "to have a link with url",
        @expected_href.inspect,
        "and onclick",
        @expected_onclick.inspect
      ].join("\n")
    end

    def negative_failure_message
      [
        "expected #{@doc.inner_html.inspect}",
        "not to have a link with url",
        @expected_href.inspect,
        "and onclick",
        @expected_onclick.inspect
      ].join("\n")
    end
  end

  def have_link(url, options={})
    HaveLink.new(self, url, options)
  end
end
