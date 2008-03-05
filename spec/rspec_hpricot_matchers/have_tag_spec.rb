require File.dirname(__FILE__) + '/../spec_helper'

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

  it "should support nested have_tag() calls" do
    @html.should have_tag('ul') do |ul|
      ul.should have_tag('li')
    end
  end

  it "should support negated nested have_tag() calls" do
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
    html.should have_tag('li') do |li|
      li.should have_tag('a')
      li.should_not have_tag('span')
    end
  end

  it "should yield element which respond to #body" do
    @html.should have_tag('ul') do |ul|
      ul.should respond_to(:body)
    end
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
end
