FactoryGirl.define do
  factory :channel
  factory :item do
    channel { build :channel }
  end
end
