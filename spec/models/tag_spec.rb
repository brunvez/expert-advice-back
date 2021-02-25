require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to validate_uniqueness_of(:text) }
end
