module KISSGen
  class Template
    attr_reader :path, :copy_path
    
    def initialize(path, copy_path)
      @path = path
      @copy_path = copy_path
    end
    
    # This will create the file with parsed data in the destination directory
    def create
      puts copy_path
      FileUtils.mkdir_p(File.dirname(copy_path))
      @file = File.new copy_path, "w"
      @file.print output # Taylor OWNZ
      @file.close
    end
    
    # Parsed ERB output
    def output
      ERB.new(IO.read(path)).result
    end
    
    # Will remove the file if it exists
    def delete
      raise "Need to create the file first. File: #{@file.inspect}" unless @file
      File.delete(copy_path)
    end

  end
end