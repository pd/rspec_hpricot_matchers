require 'rake/gempackagetask'
require 'spec/rake/spectask'

task :default => :spec
Spec::Rake::SpecTask.new

gemspec = Gem::Specification.new do |spec|
  spec.name = 'rspec_hpricot_matchers'
  spec.summary = "Implementation of have_tag() rspec matcher using Hpricot"
  spec.version = '1.0'
  spec.author = 'Kyle Hargraves'
  spec.email = 'philodespotos@gmail.com'
  spec.description = <<-END
    rspec_hpricot_matchers provides an implementation of rspec_on_rails'
    have_tag() matcher which does not depend on Rails' assert_select.
    Using Hpricot instead, the matcher is available to non-Rails projects,
    and enjoys the full flexibility of Hpricot's advanced CSS and XPath
    selector support.
  END
  spec.files = FileList['lib/**/*', 'spec/**/*', 'README', 'MIT-LICENSE', 'Rakefile']

  spec.rubyforge_project = 'rspec-hpricot'
  spec.homepage = 'http://rspec-hpricot.rubyforge.org'
end

Rake::GemPackageTask.new(gemspec) do |spec|
end
