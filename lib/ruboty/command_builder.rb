module Ruboty
  class CommandBuilder
    include Mem

    attr_reader :arguments

    def initialize(arguments = ARGV)
      @arguments = arguments
    end

    def build
      command_class.new(options)
    end

    private

    def command_class
      case
      when options[:generate]
        Commands::Generate
      when options[:help]
        Commands::Help
      else
        Commands::Run
      end
    end

    def options
      Slop.parse(arguments) do |options|
        options.on("--daemon", "Run as a daemon.")
        options.on("--dotenv", "Load .env before running.")
        options.on("-g", "--generate", "Generate a new chatterbot with ./ruboty/ directory if specified.")
        options.on("-h", "--help", "Display this help message.")
        if Slop::VERSION >= "4.0.0"
          options.string("-l", "--load", "Load a ruby file before running.")
          options.string("--pid", "Write the PID to a file.")
        else
          options.on("-l", "--load=", "Load a ruby file before running.")
          options.on("--pid=", "Write the PID to a file.")
        end
      end
    end
    memoize :options
  end
end
