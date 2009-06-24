Gem::Specification.new do |s|
  s.name              = "dependencies"
  s.version           = "0.0.2"
  s.summary           = "Specify your project's dependencies in one file."
  s.authors           = ["Damian Janowski", "Michel Martens"]
  s.email             = ["djanowski@dimaion.com", "michel@soveran.com"]

  s.rubyforge_project = "dependencies"

  s.executables << "dep"

  s.files = ["Rakefile", "bin/dep", "dependencies.gemspec", "lib/dependencies/dep.rb", "lib/dependencies.rb", "test/dependencies_test.rb", "test/vendor/barz-2.0", "test/vendor/baz-1.0"]
end
