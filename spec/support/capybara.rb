RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Warden::Test::Helpers
  config.after :each do
    Warden.test_reset!
  end
end