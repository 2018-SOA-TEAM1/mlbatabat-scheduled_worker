# frozen_string_literal: true

require 'http'
require 'json'

module MLBAtBat
  module Gateway
    # Infrastructure to call CodePraise API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def find_game_db(date, team_name)
        @request.find_game_db(date, team_name)
      end

      # app: services/list_db_game.rb
      def find_first_game
        @request.find_first_game
      end

      def find_all_games
        @request.find_all_games
      end

      # from MLB API
      def search_game(date, team_name)
        @request.search_game(date, team_name)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + '/api/v1'
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def find_game_db(date, team_name)
          call_api('get', ['games', date, team_name])
        end

        def find_all_games
          call_api('get', ['games'])
        end

        def find_first_game
          call_api('get', %w[games first])
        end

        def search_game(date, team_name)
          call_api('post', ['games', date, team_name])
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .yield_self { |str| str ? '?' + str : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .yield_self { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_STATUS = (200..299).freeze

        def success?
          SUCCESS_STATUS.include? code
        end

        def message
          puts payload
          puts payload.class
          payload['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
