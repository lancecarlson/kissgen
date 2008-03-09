require "rake"
require "rake/clean"
require "rake/gempackagetask"
require "rake/rdoctask"
require "spec/rake/spectask"

require "lib/kissgen/version"

NAME = "kissgen"

spec = Gem::Specification.new do |s|
  s.name         = NAME
  s.version      = KISSGen::VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Lance Carlson"
  s.email        = "lancecarlson@gmail.com"
  s.homepage     = "http://kissgen.rubyforge.org"
  s.summary      = "A Simple Code Generator"
  s.bindir       = "bin"
  s.description  = s.summary
  s.executables  = %w( kissgen )
  s.require_path = "lib"
  s.files        = %w( LICENSE README Rakefile ) + Dir["{bin,spec,lib}/**/*"]
  s.has_rdoc         = true
  s.extra_rdoc_files = %w( README LICENSE )
  s.required_ruby_version = ">= 1.8.4"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

##############################################################################
# installation & removal
##############################################################################
desc "Run :package and install the resulting .gem"
task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS}}
end

desc "Run :clean and uninstall the .gem"
task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

##############################################################################
# specs
##############################################################################
desc "Run specs"
Spec::Rake::SpecTask.new("specs") do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts  = File.read("spec/spec.opts").split("\n")
end

desc "Run specs with coverage"
Spec::Rake::SpecTask.new("rcov") do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts  = File.read("spec/spec.opts").split("\n")
  t.rcov = true
  t.rcov_opts = ['--exclude', 'gems', '--exclude', 'spec']
end

##############################################################################
# documentation
##############################################################################
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'KISSGen'
  rdoc.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.rdoc_files.include("README", "LICENSE")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

desc 'send rdoc to rubyforge'
task :rf_doc do
  sh %{sudo chmod -R 755 doc}
  sh %{/usr/bin/scp -r -p doc/* lancelot@rubyforge.org:/var/www/gforge-projects/kissgen}
end

##############################################################################
# misc
##############################################################################
task :release => :package do
  sh %{rubyforge add_release #{NAME} #{NAME} "#{KISSGen::VERSION}" pkg/#{NAME}-#{KISSGen::VERSION}.gem}
end