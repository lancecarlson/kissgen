module KISSGen
  class Template
    class SourceFileNotFoundError < StandardError; end
    
    attr_reader :generator, :path
    
    def initialize(generator, path, copy_path)
      @generator = generator
      @path = path
      @copy_path = copy_path
      
      source_path_check
    end
    
    def copy_path
      @copy_path.gsub(/%([^\}]*)%/) {|a| @generator.assigns[$1.to_sym]} # Yehuda OWNZ
    end
    
    def source_path_check
      raise SourceFileNotFoundError, "Template source file could not be found at #{full_source_path}" unless File.exists?(full_source_path)
    end
    
    def full_source_path
      File.join @generator.path, path
    end
    
    def full_copy_path
      File.join @generator.copy_path, copy_path
    end
    
    # Parsed ERB output
    def output
      b = binding
      
      # define local assignment variables
      @generator.assigns.each { |name, value| eval "#{name} = \"#{value}\"", b }
      
      ERB.new(File.read(full_source_path), 0, "%<>").result(b)
    end
    
    def write_or_prompt
      if File.exists?(full_copy_path)
        print "Already exists. Replace? (Yn)"
        @replace = gets.chomp
        if ["Y","y",""].include? @replace
          write
          puts "#{copy_path} replaced."
        else
          puts "#{copy_path} preserved."
        end
      else
        write
      end
    end
    
    # This will create the file with parsed data in the destination directory
    def create
      puts copy_path
      FileUtils.mkdir_p(File.dirname(full_copy_path))

      write_or_prompt
    end
    
    def write
      @file = File.new full_copy_path, "w"
      @file.print output # Taylor OWNZ
      @file.close
    end
    
    # Will remove the file if it exists
    def delete
      raise "Need to create the file first. File: #{@file.inspect}" unless @file
      File.delete(full_copy_path)
    end

  end
end