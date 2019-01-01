require 'econfig'

module MLBAtBat
  # set enviroument
  class ScheduleWorker
    extend Econfig::Shortcut
    Econfig.env = ENV['WORKER_ENV'] || 'development'
    Econfig.root = File.expand_path('..', File.dirname(__FILE__))
  end
end
