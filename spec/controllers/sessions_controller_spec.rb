# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions Controller', type: :request do
  let!(:user) { create(:user, activated: false) }
  let!(:new_user_attr) do
    attributes_for(
      :user,
      username: Faker::Name.unique.first_name[1..6],
      email: Faker::Internet.unique.email,
      phone: '34567890123'
    )
  end
  let!(:user_2) { create(:user, new_user_attr) }

  # create action
  describe '#create' do
    context 'when user is not activated' do
      it 'redirects to the home page' do
        sign_in user
        expect(response).to redirect_to root_url
        expect(flash[:danger]).to eq "Account not activated. Check your email for the activation link."
      end
    end

    context 'when username or password is wrong' do
      it 'redirects to the home page' do
        user.password = '123456'
        sign_in user
        expect(response).to redirect_to users_path
        expect(flash[:danger]).to eq "Invalid email/password combination"
      end
    end
  end

  # destroy action
  describe '#describe' do
    before { sign_in user_2 }
    it 'logs out the user' do
      expect(response).to redirect_to groups_path
      delete logout_path
      expect(response).to redirect_to root_url
    end
  end
end
