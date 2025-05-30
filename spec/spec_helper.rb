ENV["APP_ENV"] = "test"

require "rspec"
require "timecop"
# require "rack/test"
# require "super_diff/rspec"

# RSpec.configure do |config|
#   config.include Rack::Test::Methods
# end

require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.filter_run_when_matching :focus
end
