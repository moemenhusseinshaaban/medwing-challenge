require 'rails_helper'

RSpec.describe Reading, type: :model do
  it { is_expected.to validate_presence_of(:temperature) }
  it { is_expected.to validate_presence_of(:humidity) }
  it { is_expected.to validate_presence_of(:battery_charge) }
end
