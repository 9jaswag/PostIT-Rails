require 'rails_helper'

# Test suite for the GroupMember model
RSpec.describe GroupMember, type: :model do
  # Association test
  it { should belong_to(:group) }
  it { should belong_to(:user) }
end
