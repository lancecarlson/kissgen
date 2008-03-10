require "erb"
require "fileutils"
require "pathname"

dir = File.join(File.dirname(__FILE__), "kissgen")
files = %w{generator template version}
files.each { |f| require(File.join(dir, f)) }
