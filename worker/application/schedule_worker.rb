# frozen_string_literal: true

require_relative '../../init.rb'
require_relative './mlb_at_bat_api.rb'
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

    # schedule worker's job
    def search_all_team
      @queue.poll do |schedule_request_json|
        schedule_request = Representer::ScheduleRequest
                           .new(OpenStruct.new)
                           .from_json(schedule_request_json)
        date_api = split_date(schedule_request.date)

        # call mlbatbat-api to update particular game
        Gateway::Api.new(MLBAtBat::ScheduleWorker.config)
                    .find_game_db(date_api,
                                  schedule_request.team_name)
      end
    end

    def split_date(date)
      date.split('/').join('_')
    end
  end
end
