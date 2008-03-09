require 'erb'
require 'fileutils'
require 'pathname'

files = %w[
  generator template version
]
dir = File.join(File.dirname(__FILE__), "kissgen")
files.each {|f| require(File.join(dir, f))}
