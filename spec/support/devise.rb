
module ControllerMacros

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      #user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end
    
end

RSpec.configure do |config|
  # For Devise <= 4.1.0
  config.include Devise::Test::ControllerHelpers, :type => :controller
  # Use the following instead if you are on Devise >= 4.1.1
  # config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller

end
