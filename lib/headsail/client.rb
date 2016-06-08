require 'headsail/task'

module Headsail
  class Client
    def initialize(configure)
      @configure = configure
      @threads = []
      @tasks = []
      setup_tasks
    end

    def run
      @tasks.each { |task| @threads << task.run }
      @threads.map(&:execute)
      loop { sleep 300 }
    end

    private

    def setup_tasks
      @configure.apis.each { |api| @tasks << Task.new(api) }
    end
  end
end