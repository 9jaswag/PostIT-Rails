require 'rails_helper'

# Test suite for the Message model
RSpec.describe Message, type: :model do
  # Association test
  it { should belong_to(:user) }
  it { should belong_to(:group) }

  # Validation tests
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:readby) }
  it { should validate_presence_of(:group_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:priority) }
end
