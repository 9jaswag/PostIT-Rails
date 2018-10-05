require 'rails_helper'

RSpec.describe 'Groups Controller', type: :request do

  # #index
  describe '#index' do
    context 'when user is not signed in' do
      before { get groups_path }
      it 'redirects the user to sign up page' do
        expect(response).to redirect_to users_path
      end
    end
  end
end
