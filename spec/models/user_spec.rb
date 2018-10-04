require 'rails_helper'

# Test suite for the User model
RSpec.describe User, type: :model do
  # Association test
  it { should have_many(:group_members) }
  it { should have_many(:groups).through(:group_members) }
  it { should have_many(:messages) }

  # Validation tests
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:password) }
end
