module RCGen
  class Template
    attr_reader :path, :copy_directory
    
    def initialize(path, copy_directory)
      @path = path
      @copy_directory = copy_directory
    end
    
    # Taylor OWNZ
    def create
      puts "Created #{new_path}"
      @file = File.new new_path, "w"
      @file.print output
      @file.close
    end
    
    def new_path
      File.join(copy_directory, "/", File.basename(path))
    end
    
    def output
      ERB.new(IO.read(path)).result
    end
    
    def delete
      raise "Need to create the file first" unless @file
      File.delete(new_path)
    end

  end
end