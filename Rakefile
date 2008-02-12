require "rake"
require "rake/clean"
require "rake/gempackagetask"
require "rake/rdoctask"
require "spec/rake/spectask"

require "lib/rcgen/version"

NAME = "rcgen"

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = RCGen::VERSION
  s.platform     = Gem::Platform::RUBY
  s.author       = "Lance Carlson"
  s.email        = "lancecarlson@gmail.com"
  s.homepage     = "http://rcgen.rubyforge.org"
  s.summary      = "A Simple Code Generator"
  s.bindir       = "bin"
  s.description  = s.summary
  s.executables  = %w( rcgen )
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
