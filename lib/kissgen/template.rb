module KISSGen
  class Template
    class SourceFileNotFoundError < StandardError; end
    attr_reader :generator, :path, :copy_path
    
    def initialize(generator, path, copy_path)
      @generator = generator
      @path = path
      @copy_path = copy_path
      
      source_path_check
    end
    
    def source_path_check
      raise SourceFileNotFoundError, "Template source file could not be found at #{full_source_path}" unless File.exists?(full_source_path)
    end
    
    def full_source_path
      File.join @generator.path, @path
    end
    
    def full_copy_path
      File.join @generator.copy_path, @copy_path
    end
    
    # This will create the file with parsed data in the destination directory
    def create
      puts copy_path
      FileUtils.mkdir_p(File.dirname(full_copy_path))
      @file = File.new full_copy_path, "w"
      @file.print output # Taylor OWNZ
      @file.close
    end
    
    # Parsed ERB output
    def output
      ERB.new(IO.read(full_source_path)).result
    end
    
    # Will remove the file if it exists
    def delete
      raise "Need to create the file first. File: #{@file.inspect}" unless @file
      File.delete(full_copy_path)
    end

  end
end