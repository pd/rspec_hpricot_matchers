require 'rubygems'
require 'nokogiri'

require 'rspec_hpricot_matchers/have_tag'
require 'rspec_hpricot_matchers/have_link'

class Nokogiri::XML::Element
  alias body to_s
end
