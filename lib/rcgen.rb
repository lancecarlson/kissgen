require 'erb'

files = %w[
  generator template
]
dir = File.join(File.dirname(__FILE__), "rcgen")
files.each {|f| require(File.join(dir, f))}
