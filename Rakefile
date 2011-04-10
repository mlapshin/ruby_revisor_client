require 'rake/testtask'

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "revisor_client"
    gemspec.summary = "Ruby helper library for Revisor browser"
    gemspec.description = "Object-oriented interface for remotelly-controller WebKit-based browser named Revisor."
    gemspec.email = "sotakone@sotakone.com"
    gemspec.homepage = "http://github.com/sotakone/revisor/"
    gemspec.description = ""
    gemspec.authors = ["Mikhail Lapshin"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
end

Rake::TestTask.new(:examples) do |t|
  t.test_files = FileList['examples/*_example.rb']
end
