# frozen_string_literal: true

require_relative '../../init.rb'
require 'aws-sdk-sqs'

module MLBAtBat
  # Scheduled worker to get latest schedule in MLB
  class ScheduleWorker
    def initialize
      @config = ScheduleWorker.config
      @queue = MLBAtBat::Messaging::Queue.new(
        @config.SCHEDULE_QUEUE_URL, @config
      )
    end

    def call
      # Once schedule job on heroku
      # Will poll all messages from SQS
      puts "Start Schedule worker. DateTime: #{Time.now}"
      search_all_team
      puts 'End Schedule worker'
    end

    # schedule worker's jib
    def search_all_team
      @queue.poll do |schedule_request_json|
        schedule_request = Representer::ScheduleRequest
                           .new(OpenStruct.new)
                           .from_json(schedule_request_json)
        puts schedule_request.date
        puts schedule_request.game_pk
        puts 

        # call mlbatbat-api to update(?) particular game
        # not yet ... 
      end
    end
  end
end
