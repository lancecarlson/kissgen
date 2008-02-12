module RCGen
  # The generator class is where you configure path and import files
  # 
  #   require 'rcgen'
  #   RCGen::Generator.new "/path/to/generator"
  #   RCGen::Generator.generate
  #   
  class Generator
    attr_reader :path, :files
    
    def initialize(path)
      @path = path
      @files = []
      
      import_setup
    end
    
    # Import setup file which is located in /path/to/generator/setup.rb
    def import_setup
      self.instance_eval File.read(directory.path + "/setup.rb")
    end
    
    # A standard directory object of the path
    def directory
      Dir.new(path)
    end
    
    def full_path(relative_path)
      File.expand_path(File.join(directory.path, "/", relative_path))
    end
    
    def generate
      @files.each do |file|
        file.create
      end
    end
    
    def add_file(relative_path, relative_copy_path, options = {})
      file = Template.new(
        full_path(relative_path),
        full_path(relative_copy_path)
      )
      @files << file
      file
    end
    
    def add_directory(relative_path, relative_copy_path, options = {})
      Dir["#{full_path(relative_path)}/**/*"].each do |file|
        add_file(file, relative_copy_path, options)
      end
    end
  end
end