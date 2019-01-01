# frozen_string_literal: true

require 'ostruct'

%w[config worker]
  .reduce([]) { |files, folder| files << Dir.glob("#{folder}/**/*.rb") }
  .flatten
  .each { |file| require_relative file }
