require 'rails_helper'

RSpec.describe 'Users Controller', type: :request do
  # initialize test data
  let!(:user) { create(:user) }
  # let(:valid_attributes) do
  #   attributes_for(:new_user, password_confirmation: user.password)
  # end

  # new action
  describe '#new' do
      it 'returns a successful response' do
        get new_user_path
        expect(response.success?).to eq true
      end
  end

  # show action
  describe '#show' do
    context 'when user is not signed in' do
      before { get user_path(id: user.id) }
      it 'redirects the user to sign up page' do
        expect(response).to redirect_to users_path
      end
    end

    context 'when user is signed in' do
      before do
        sign_in user
      end
      it 'redirects the users page' do
        get user_path(id: user.id)
        expect(response.body).to include "@#{user.username}"
      end
    end
  end

  # create action
  describe '#create' do
    context 'when user parameters is invalid' do
      before do
        post users_path(user: { phone: '12345678901' })
      end
      it 'renders the index page' do
        expect(response).to render_template("index")
      end
    end

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
