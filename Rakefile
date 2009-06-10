require 'spec/rake/spectask'

task :default => :spec
Spec::Rake::SpecTask.new

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = 'rspec_hpricot_matchers'
    gemspec.author = 'Kyle Hargraves'
    gemspec.email = 'pd@krh.me'
    gemspec.summary = "Implementation of have_tag() rspec matcher using Hpricot"
    gemspec.description = <<-END
      rspec_hpricot_matchers provides an implementation of rspec_on_rails'
      have_tag() matcher which does not depend on Rails' assert_select.
      Using Hpricot instead, the matcher is available to non-Rails projects,
      and enjoys the full flexibility of Hpricot's advanced CSS and XPath
      selector support.
    END

    # Really, I don't care about rubyforge. Maybe I'll get this
    # working some day.
    # gemspec.rubyforge_project = 'rspec-hpricot'
  end
rescue LoadError
  puts "Jeweler unavailable, packaging tasks can not be run. Install it, thanks."
end
