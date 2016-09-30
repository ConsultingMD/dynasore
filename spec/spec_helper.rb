$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'byebug'
require 'aws-sdk'
require 'aws-record'
require 'dynasore'

require File.expand_path("../dummy/config/environment", __FILE__)

RSpec.configure do |rspec_config|
  rspec_config.filter_run_excluding broken: true
end
