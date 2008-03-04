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
    @html.should have_tag('ul') do |e|
      e.should have_tag('li')
    end
  end

  it "should support negated nested have_tag() calls" do
    @html.should have_tag('ul') do |e|
      e.should_not have_tag('dd')
    end
  end

  it "should treat multiple nested have_tag() expectations as a logical AND" do
    @html.should have_tag('ul') do |e|
      e.should have_tag('li')
      e.should_not have_tag('dd')
    end
  end
end
