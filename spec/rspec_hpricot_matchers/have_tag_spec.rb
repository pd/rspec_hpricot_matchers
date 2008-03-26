require File.dirname(__FILE__) + '/../spec_helper'

unless defined?(SpecFailed)
  SpecFailed = Spec::Expectations::ExpectationNotMetError
end

describe 'have_tag' do
  before(:each) do
    @html = "<ul><li>An egregiously long string</li></ul>"
  end

  it "should match against strings" do
    @html.should have_tag('li')
  end

  it "should match against Hpricot documents" do
    hdoc = Hpricot(@html)
    hdoc.should have_tag('li')
  end

  it "should use the response of #body if the target responds to it" do
    response = Object.new
    class << response
      def body
        "<ul><li>An egregiously long string</li></ul>"
      end
    end
    response.should have_tag('li')
  end

  it "should not match when the target does not have the selected element" do
    @html.should_not have_tag('dd')
  end

  it "should match against the inner text of the selected element" do
    @html.should have_tag('li', 'An egregiously long string')
  end

  it "should match negatively against the inner text" do
    @html.should_not have_tag('li', 'Some other string entirely')
  end

  it "should match against a Regexp describing the inner text" do
    @html.should have_tag('li', /GREG/i)
  end

  it "should match negatively against a Regexp describing the inner text" do
    @html.should_not have_tag('li', /GREG/)
  end

  it "should include the body in the failure message" do
    lambda {
      @html.should have_tag('abbr')
    }.should raise_error(SpecFailed, /#{Regexp.escape(@html)}/)
  end

  it "should include the selector in the failure message" do
    lambda {
      @html.should have_tag('abbr')
    }.should raise_error(SpecFailed, /"abbr"/)
  end

  it "should include the expected inner text if provided" do
    lambda {
      @html.should have_tag('li', /something else/)
    }.should raise_error(SpecFailed, %r{/something else/})
  end
end

describe 'have_tag inner expectations' do
  before(:each) do
    @html = "<ul><li>An egregiously long string</li></ul>"
  end

  it "should fail when the outer selector fails" do
    lambda {
      @html.should have_tag('dl') do |dl|
        dl.should have_tag('li')
      end
    }.should raise_error(SpecFailed)
  end

  it "should match the inner expectations against the elements matched by the outer selector" do
    @html.should have_tag('ul') do |ul|
      ul.should have_tag('li')
    end
  end

  it "should support negated inner expectations" do
    @html.should have_tag('ul') do |ul|
      ul.should_not have_tag('dd')
    end
  end

  it "should treat multiple nested have_tag() expectations as a logical AND" do
    @html.should have_tag('ul') do |ul|
      ul.should have_tag('li')
      ul.should_not have_tag('dd')
    end
  end

  it "should only match against a single element at a time when nesting expectations (see RSpec LH#316)" do
    html = <<-EOHTML
      <ul>
        <li>
          <a href="1">1</a>
        </li>
        <li>
          <a href="2">2</a>
          <span>Hello</span>
        </li>
      </ul>
    EOHTML

    html.should have_tag('li', :count => 1) do |li|
      li.should have_tag('a')
      li.should have_tag('span')
    end

    html.should have_tag('li', :count => 1) do |li|
      li.should have_tag('a')
      li.should_not have_tag('span')
    end

    html.should have_tag('li', :count => 2) do |li|
      li.should have_tag('a')
    end
  end

  it "should yield elements which respond to #body" do
    @html.should have_tag('ul') do |ul|
      ul.should respond_to(:body)
    end
  end

  it "should supports arbitrary expectations within the block" do
    html = %q{<span class="sha1">cbc0bd52f99fe19304bccad383694e92b8ee2c71</span>}
    html.should have_tag('span.sha1') do |span|
      span.inner_text.length.should == 40
    end
    html.should_not have_tag('span.sha1') do |span|
      span.inner_text.length.should == 41
    end
  end

  it "should include a description of the inner expectation in the failure message" do
    pending "No idea how to implement this."
  end
end

describe 'have_tag with counts' do
  before(:each) do
    @html = <<-EOHTML
      <ul>
        <li>Foo</li>
        <li>Bar</li>
        <li>Foo again</li>
        <li><a href="/baz">With inner elements</a></li>
      </ul>
    EOHTML
  end

  it "should treat an integer :count as expecting exactly n matched elements" do
    @html.should have_tag('li', :count => 4)
    @html.should_not have_tag('li', :count => 3)
    @html.should_not have_tag('li', :count => 5)
  end

  it "should treat a range :count as expecting between x and y matched elements" do
    @html.should have_tag('li', :count => 1..5)
    @html.should_not have_tag('li', :count => 2..3)
  end

  it "should treat a :count of zero as if a negative match were expected" do
    @html.should have_tag('dd', :count => 0)
  end

  it "should treat :minimum as expecting at least n matched elements" do
    (0..4).each { |n| @html.should have_tag('li', :minimum => n) }
    @html.should_not have_tag('li', :minimum => 5)
  end

  it "should treat :maximum as expecting at most n matched elements" do
    @html.should_not have_tag('li', :maximum => 3)
    @html.should have_tag('li', :maximum => 4)
    @html.should have_tag('li', :maximum => 5)
  end

  it "should support matching of content while specifying a count" do
    @html.should have_tag('li', /foo/i, :count => 2)
  end

  it "should work when the have_tag is nested" do
    @html.should have_tag('ul') do |ul|
      ul.should have_tag('li', :minimum => 2)
      ul.should have_tag('li', /foo/i, :count => 2)
    end
  end

  it "should include the actual number of elements matched in the failure message" do
    lambda {
      @html.should have_tag('li', :count => 3)
    }.should raise_error(SpecFailed, /found 4/)
    lambda {
      @html.should have_tag('li', :count => 5)
    }.should raise_error(SpecFailed, /found 4/)
  end

  it "should include the actual number of elements matched in the negative failure message" do
    lambda {
      @html.should_not have_tag('li', :count => 4)
    }.should raise_error(SpecFailed, /found 4/)
  end

  it "should include the expected number of elements in the failure message" do
    lambda {
      @html.should have_tag('li', :count => 2)
    }.should raise_error(SpecFailed, /to have 2 elements matching/)
  end

  it "should include the expected number of elements in the negative failure message" do
    lambda {
      @html.should_not have_tag('li', :count => 4)
    }.should raise_error(SpecFailed, /to have 4 elements matching/)
  end

  it "should describe the :minimum case using 'at least ...'" do
    lambda {
      @html.should have_tag('li', :minimum => 80)
    }.should raise_error(SpecFailed, /to have at least 80 elements matching/)
  end

  it "should describe the :maximum case using 'at most ...'" do
    lambda {
      @html.should have_tag('li', :maximum => 2)
    }.should raise_error(SpecFailed, /to have at most 2 elements matching/)
  end

  it "should describe the :minimum and :maximum case using 'at least ... and at most ...'" do
    lambda {
      @html.should have_tag('li', :minimum => 8, :maximum => 30)
    }.should raise_error(SpecFailed, /to have at least 8 and at most 30 elements matching/)
  end
end
