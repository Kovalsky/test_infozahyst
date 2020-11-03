FactoryBot.define do
  factory :reservation do
    user { nil }
    restaurant { nil }
    start_time { 1 }
    end_time { 1 }
  end
end
