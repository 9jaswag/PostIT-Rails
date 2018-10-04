require 'rails_helper'

# Test suite for the Group model
RSpec.describe Group, type: :model do
  # Association test
  it { should have_many(:group_members) }
  it { should have_many(:users).through(:group_members) }
  it { should have_many(:messages) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner) }
  it { should validate_presence_of(:description) }
end
