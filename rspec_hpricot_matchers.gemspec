# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec_hpricot_matchers}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kyle Hargraves"]
  s.date = %q{2009-06-09}
  s.description = %q{rspec_hpricot_matchers provides an implementation of rspec_on_rails' have_tag() matcher which does not depend on Rails' assert_select. Using Hpricot instead, the matcher is available to non-Rails projects, and enjoys the full flexibility of Hpricot's advanced CSS and XPath selector support.}
  s.email = %q{pd@krh.me}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    ".gitignore",
     "MIT-LICENSE",
     "README",
     "Rakefile",
     "VERSION",
     "lib/rspec_hpricot_matchers.rb",
     "lib/rspec_hpricot_matchers/have_tag.rb",
     "spec/rspec_hpricot_matchers/have_tag_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Implementation of have_tag() rspec matcher using Hpricot}
  s.test_files = [
    "spec/rspec_hpricot_matchers/have_tag_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
