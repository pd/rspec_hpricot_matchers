require 'rubygems'
require 'nokogiri'

require 'rspec_hpricot_matchers/have_tag'

class Nokogiri::XML::Element
  alias body inner_html
end
