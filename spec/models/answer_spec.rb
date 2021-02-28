require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to validate_presence_of(:question) }
  it { is_expected.to validate_presence_of(:user) }
end
