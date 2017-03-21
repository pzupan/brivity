require 'rails_helper'

RSpec.describe Post, :type => :model do
  it "is valid with valid attributes" do
    new_post = create(:post)
    expect(new_post).to be_valid
  end
end