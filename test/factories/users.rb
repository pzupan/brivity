FactoryGirl.define do
  factory :user do
    sequence :email do |n|
        "person_#{n}@example.com"
    end
    password '12345678'
    first_name "John"
    last_name  "Doe"
    confirmed_at DateTime.now
  end
end