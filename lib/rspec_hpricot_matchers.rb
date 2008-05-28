require 'rubygems'
require 'hpricot'
require 'rspec_hpricot_matchers/have_tag'
require 'rspec_hpricot_matchers/have_link'

# evil hack to duck-type CgiResponse so that nested shoulds can use 
# +rspec_on_rails+ matchers without remembering to call to_s on it
#
# e.g.
#
# response.should have_tag("li") do |ul|
#   ul.should have_text("List Item")      # with hack
#   ul.to_s.should have_text("List Item") # without hack
# end
class Hpricot::Elem
  alias body to_s
end
