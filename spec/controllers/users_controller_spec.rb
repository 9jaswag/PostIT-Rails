require 'rails_helper'

RSpec.describe 'Users Controller', type: :request do
  # initialize test data
  let!(:user) { create(:user) }
  # let!(:new_user) { build(:user) }
  # let(:valid_attributes) do
  #   attributes_for(:new_user, password_confirmation: user.password)
  # end

  # #show
  describe '#show' do
    context 'when user is not signed in' do
      before { get user_path(id: user.id) }
      it 'redirects the user to sign up page' do
        expect(response).to redirect_to users_path
      end
    end
  end

  # #create
  describe '#create' do
    context 'when user parameters is valid' do
      before do
        post users_path(user: {
                          username: 'Troy34',
                          password: 'password',
                          email: 'troy34@email.com',
                          phone: '12345678901'
                        })
      end
      it 'creates a user' do
        expect(User.last.username).to eq 'troy34'
      end
    end
  end
end
