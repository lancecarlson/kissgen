module KISSGen
  class Template
    class SourceFileNotFoundError < StandardError; end
    
    attr_reader :generator, :source
    
    def initialize(generator, source, target)
      @generator = generator
      @source    = source
      @target    = target
      
      source_check
    end
    
    def target
      @target.gsub(/%([^\}]*)%/) {|a| @generator.assigns[$1.to_sym]} # Yehuda OWNZ
    end
    
    def source_check
      raise SourceFileNotFoundError, "Template source file could not be found at #{full_source}" unless File.exists?(full_source)
    end
    
    def full_source
      File.join @generator.path[:source], source
    end
    
    def full_target
      File.join @generator.path[:target], target
    end
    
    # Parsed ERB output
    def output
      b = binding
      
      # define local assignment variables
      @generator.assigns.each { |name, value| eval "#{name} = \"#{value}\"", b }
      
      ERB.new(File.read(full_source), 0, "%<>").result(b)
    end
    
    def write_or_prompt
      if File.exists?(full_target)
        print "Already exists. Replace? (Yn)"
        @replace = gets.chomp
        if ["Y","y",""].include? @replace
          write
          puts "#{target} replaced."
        else
          puts "#{target} preserved."
        end
      else
        write
      end
    end
    
    # This will create the file with parsed data in the destination directory
    def create
      puts target
      FileUtils.mkdir_p(File.dirname(full_target))
      write_or_prompt
    end
    
    def write
      @file = File.new full_target, "w"
      @file.print output # Taylor OWNZ
      @file.close
    end
    
    # Will remove the file if it exists
    def delete
      raise "Need to create the file first. File: #{@file.inspect}" unless @file
      File.delete(full_target)
    end

  end
end
