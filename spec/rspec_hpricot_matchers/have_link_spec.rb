require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

describe 'have_link' do
  attr_reader :fixture, :link, :html
  before(:each) do
    @fixture = Object.new
    fixture.extend RspecHpricotMatchers
    @html = "<div><a href='/foo/bar' onclick='deleteJsFunction();'>Some Text</a></div>"
  end

  def template
    @template ||= Object.new
  end

  describe "when the expected link does not have an onclick handler" do
    describe "when href match found" do
      it "passes" do
        template.should_receive(:link_to).with('ignore-me', '/foo/bar', {}).and_return(
          "<a href='/foo/bar'>ignore-me</a>"
        )

        hdoc = Hpricot(html)
        hdoc.should have_link('/foo/bar')
      end
    end

    describe "when href match not found" do
      it "fails" do
        template.should_receive(:link_to).with('ignore-me', '/foo/bar/baz', {}).and_return(
          "<a href='/foo/bar/baz'>ignore-me</a>"
        )

        hdoc = Hpricot(html)
        lambda {
          hdoc.should have_link('/foo/bar/baz')
        }.should raise_error(SpecFailed, /to have a link with url/)
      end
    end
  end

  describe "when the expected link has on onclick handler" do
    describe "when href match found" do
      describe "when onclick match found" do
        it "passes" do
          template.should_receive(:link_to).with('ignore-me', '/foo/bar', {:method => :delete}).and_return(
          "<a href='/foo/bar' onclick='deleteJsFunction();'>ignore-me</a>"
          )

          hdoc = Hpricot(html)
          hdoc.should have_link('/foo/bar', :method => :delete)
        end
      end

      describe "when onclick match not found" do
        it "fails" do
          template.should_receive(:link_to).with('ignore-me', '/foo/bar', {:method => :create}).and_return(
            "<a href='/foo/bar' onclick='createJsFunction();'>ignore-me</a>"
          )

          hdoc = Hpricot(html)
          lambda {
            hdoc.should have_link('/foo/bar', :method => :create)
          }.should raise_error(SpecFailed, /and onclick/)
        end
      end
    end

    describe "when href match not found" do
      it "fails" do
        template.should_receive(:link_to).with('ignore-me', '/foo/bar/baz', {:method => :delete}).and_return(
          "<a href='/foo/bar/baz' onclick='createJsFunction();'>ignore-me</a>"
        )

        hdoc = Hpricot(html)
        lambda {
          hdoc.should have_link('/foo/bar/baz', :method => :delete)
        }.should raise_error(SpecFailed, /to have a link with url/)
      end
    end
  end
end
