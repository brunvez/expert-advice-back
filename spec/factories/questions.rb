FactoryBot.define do
  factory :question do
    title { 'Why?' }
    description { 'Because' }
    association(:creator, factory: :user)
  end
end