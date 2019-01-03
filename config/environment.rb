require 'econfig'
require 'rack/cache'
require 'redis-rack-cache'
require 'roda'

module MLBAtBat
  # set enviroument 
  class ScheduleWorker < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = ENV['WORKER_ENV'] || 'development'
    Econfig.root = File.expand_path('..', File.dirname(__FILE__))

    use Rack::Cache,
        verbose: true,
        metastore: config.REDIS_URL + '/0/metastore',
        entitystore: config.REDIS_URL + '/0/entitystore'
  end
end
