require 'optparse'
require 'headsail/configure'
require 'headsail/launcher'

module Headsail
  # Handles the start of Headsail via command line
  #
  class CLI
    attr_reader :launcher, :configure

    # Creates a new CLI object, parsing the arguments that are passed to it,
    # and readying a Launcher to be run
    #
    def initialize(argv)
      @argv = argv
      @configure = nil
      @parser = nil

      setup_options
      parse_options
      @launcher = Launcher.new(@configure)
    end

    def run
      @launcher.run
    end

    private

    # Builds a Configure object based on options passed through the
    # command line arguments.
    #
    def setup_options
      @configure = Headsail::Configure.new.tap do |c|
        @parser = OptionParser.new do |o|

          o.banner = 'Usage: bundle exec bin/headsail [options]'

          o.on('-a', '--apis PATH', 'Load PATH for api yaml file') do |arg|
            c.load_apis(arg)
          end

          o.on('-s', '--start', 'Start the Headsail client') do
            c.start_client = true
          end

          o.on('-h', '--help', 'Prints this help') do
            puts o
            exit
          end

        end
      end
    end

    def parse_options
      @parser.parse!(@argv)
    rescue
      Headsail.err('Unsupported options entered in CLI.', :exit)
    end
  end
end
