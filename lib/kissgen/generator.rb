module KISSGen
  # The generator class is where you configure path and import files
  # 
  #   require 'rcgen'
  #   KISSGen::Generator.new "/path/to/generator", "/path/where/files/are/generated"
  #   KISSGen::Generator.generate(:pretend => true)
  #   KISSGen::Generator.generate
  class Generator
    class SetupFailure < StandardError; end
    
    attr_reader :path, :copy_path, :files
    attr_accessor :explain_pretend, :explain_created, :explain_footer
    attr_accessor :setup_file_path
    
    def initialize(path, copy_path)
      @path = path
      @copy_path = copy_path
      @files = []
      @explain_pretend = "== PRETEND MODE: Would have created the following files: =="
      @explain_generate = "== Generated the following files: =="
      @explain_footer = "====== Generator Finished ======"
      
      import_setup
    end
    
    def setup_file_path
      @path + "/setup.rb"
    end
    
    # Import setup file which is located in /path/to/generator/setup.rb
    def import_setup
      raise SetupFailure, "Setup file does not exist in #{File.expand_path(setup_file_path)}" unless File.exists?(setup_file_path)
      instance_eval(File.new(setup_file_path).read)
    end
    
    def generate(options = {})
      puts(options[:pretend] ? @explain_pretend : @explain_generate)
      
      @files.each do |file|
        puts(options[:pretend] ? "#{file.copy_path}" : file.create)
      end
      
      puts @explain_footer
    end
    
    # Adds a file to the list of files to generate
    # 
    # This will generate the template README file relative to the copy path
    #
    #   file "README"
    #
    # or
    #
    #   file "README", "README_PLEASE"
    def file(relative_file_path, relative_copy_path = relative_file_path, options = {})
      template = Template.new(self, relative_file_path, relative_copy_path)
      @files << template
      template
    end
    
    # Recursively adds a directory to the list of files to generate
    # 
    # directory "app"
    def directory(directory_path, relative_copy_path = directory_path, options = {})
      Dir["#{File.join(@path, directory_path)}/**/*"].each do |file_path|
        unless FileTest.directory?(file_path)
          # Take the template file path and give relative paths
          relative_path = Pathname.new(file_path).relative_path_from(Pathname.new(File.join(@path, directory_path)))
          new_path = File.join(relative_copy_path, relative_path)
          @files << Template.new(self, File.join(directory_path, relative_path), new_path)
        end
      end
    end
  end
end