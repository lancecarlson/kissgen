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
      @setup_file_path = @path + "/setup.rb"
      
      import_setup
    end
    
    # Import setup file which is located in /path/to/generator/setup.rb
    def import_setup
      raise SetupFailure, "Generator path does not exist in #{File.expand_path(@path)}" unless File.stat(@path).directory?
      raise SetupFailure, "Setup file does not exist in #{File.expand_path(@setup_file_path)}" unless File.exists?(@setup_file_path)
      require @setup_file_path
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
    #   file "README", "/../empty"
    def file(relative_file_path, relative_copy_path = "/", options = {})
      template = Template.new(
        File.join(@path, relative_file_path), 
        File.join(@path, relative_copy_path)
      )
      @files << template
      template
    end
    
    def directory(directory_path, relative_copy_path, options = {})
      #Dir["#{full_path(directory_path)}/**/*"].each do |file_path|
        #unless FileTest.directory?(move_path(copy_path, directory_path, file_path))
          #add_file(file_path, move_path(copy_path, directory_path, file_path), options)
        #end
      #end
    end
    
    # Given the old directory and the new copy directory, it will return the new move path
    # Directory path: merb_app/
    # Copy Path: empty/
    # File Path: merb_app/app/blah
    def move_path(directory_path, copy_path, file_path)
      File.join(full_path(copy_path), file_path.gsub(full_path(directory_path), ""))
    end
  end
end