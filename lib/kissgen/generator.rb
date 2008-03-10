module KISSGen
  #
  # The generator class is where you configure path and import files
  #
  # == Example 1:
  #   require "kissgen"
  #   @generator = KISSGen::Generator.new("/path/to/generator", "/path/where/files/are/generated")
  #   @generator.directory = "/"
  #   @generator.assign :my_name, "lancelot"
  #   @generator.generate(:pretend => true)
  #   @generator.generate
  #
  # == Example 2:
  #   require "kissgen"
  #
  #   @generator = KISSGen.generator(
  #                    :generator => "/path/to/generator", 
  #                    :directory => "/path/where/files/are/generated", 
  #                    :pretend   => true,
  # Proposed:          :assigns  => {:my_name => "lancelot", ...},
  # Proposed:          :files     => {"app", "models"}
  #                   )
  #
  #  Now perform the generation:
  #
  #    @generator.generate!
  #
  #  Note that the last loaded generator is retrievable via:
  #
  #   @generator = KISSGen.generator # => Last loaded generator
  #   
  
  class << self
    attr_accessor :generator
    def generate(*args)
      @generator = KISSGen::Generator.new(*args)
    end
    def generate!(*options)
      generator.generate(*options)
    end
  end
  
  class Generator
    attr_reader   :path, :files, :assigns
    attr_accessor :explain
    
    def initialize(*args)
      @path = {}
      if args.class == Hash
        @path[:source] = args[:source]
        @path[:target] = args[:target]
        @assigns = args[:assigns] || {}
        # @options[:pretend] = args[:pretend]
      else
        @path[:source] = args[0]
        @path[:target] = args[1]
        @assigns = {}
      end

      @files   = []
      @explain = {
        :pretend  => "== PRETEND MODE (The following files would be created) ==",
        :generate => "== Generated the following files: ==",
        :footer   => "====== Generator Finished ======"
      }
      
      import_setup
    end
    
    def generator_file
      "#{@path[:source]}/setup.rb"
    end
    
    # Import setup file which is located in /path/to/generator/setup.rb
    def import_setup
      instance_eval(File.new(generator_file).read) if File.exists?(generator_file)
    end
    
    def generate(options = {})
      puts(options[:pretend] ? @explain[:pretend] : @explain[:generate])
      
      @files.each do |file|
        options[:pretend] ? puts("#{file.target}") : file.create
      end
      
      puts @explain[:footer]
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
    def file(relative_file_path, relative_target = relative_file_path, options = {})
      template = Template.new(self, relative_file_path, relative_target)
      @files << template
      template
    end
    
    # Recursively adds a directory to the list of files to generate
    # 
    # directory "app"
    def directory(directory_path, relative_target = directory_path, options = {})
      Dir["#{File.join(@path[:source], directory_path)}/**/*"].each do |file_path|
        unless FileTest.directory?(file_path)
          # Take the template file path and give relative paths
          relative_path = Pathname.new(file_path).relative_path_from(Pathname.new(File.join(@path[:source], directory_path)))
          new_path = File.join(relative_target, relative_path)
          @files << Template.new(self, File.join(directory_path, relative_path), new_path)
        end
      end
    end
    
    # assigns :app_file_name, "lancelot"
    def assign(name, value)
      @assigns[name] = value
    end
    
    def delete
      @files.each { |file| file.delete }
    end
  end
end
