# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module MLBAtBat
  module Representer
    # Representer object for schedule requests
    class ScheduleRequest < Roar::Decorator
      include Roar::JSON

      property :date
      property :game_pk
    end
  end
end
