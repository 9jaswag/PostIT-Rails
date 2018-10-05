require 'rails_helper'

RSpec.describe 'Users Controller', type: :request do
  # initialize test data
  let!(:user) { create(:user) }

  # #show
  describe '#show' do
    context 'when user is not signed in' do
      before { get user_path(id: user.id) }
      it 'does ish' do
        expect(response).to redirect_to users_path
      end
    end
  end
end
