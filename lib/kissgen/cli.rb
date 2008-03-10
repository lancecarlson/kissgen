require "yaml"
require "optparse"

module KISSGen

  class << self

    attr_accessor :config

    def usage
      "\n#{'='*80}\n= Examples\n#{'='*80}
      kissgen <options>
      ".gsub(/^    /,'')
    end

    def parse_args(argv = ARGV)
      @config ||= {}

      # Build a parser for the command line arguments
      OptionParser.new do |opt|
        opt.define_head "KISSGen"
        opt.banner = usage

        opt.on("-s", "--source SOURCE", "The path to the generator files.") do |generator|
          @config[:generator] = generator
        end

        opt.on("-t", "--target TARGET", "The target path, where the generated files will go.") do |base|
          @config[:target] = base
        end

        opt.on("-a", "--assigns ASSIGNMENTS", "A yaml file with variable assignments!") do |assignments|
          @config[:assignments] = YAML::load_file(assignments)
        end

        opt.on("-f", "--files FILES", "A files listing.") do |files|
          @config[:files] = files
        end

        opt.on("-p", "--practice", "Practice only, do not actually generate anything.") do
          @config[:practice] = true
        end

        opt.on("-i", "--interactive", "Interactive Mode.") do
          @config[:interactive] = true
        end
        
        opt.on("-c", "--config FILE", "Entire configuration structure, useful for testing scenarios.") do |config_file|
          @config = YAML::load_file(config_file)
        end

        # What about keeping a log?
        #opt.on("-l", "--log LOGFILE", "A string representing the logfile to use.") do |log_file|
        #  @config[:log_file] = log_file
        #end

        opt.on("-?", "-H", "--help", "Show this help message") do
          puts opt 
          exit
        end

      end.parse!(argv)

    end

  end

end

