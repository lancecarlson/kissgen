require 'erb'
require 'fileutils'

files = %w[
  generator setup template version
]
dir = File.join(File.dirname(__FILE__), "kissgen")
files.each {|f| require(File.join(dir, f))}
