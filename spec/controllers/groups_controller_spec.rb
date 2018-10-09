# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups Controller', type: :request do
  let!(:new_user_attr) do
    attributes_for(
      :user,
      username: Faker::Name.unique.first_name[1..6],
      email: Faker::Internet.unique.email,
      phone: '12345678901'
    )
  end
  let!(:new_group_attr) do
    attributes_for(
      :group,
      name: Faker::Company.unique.name[1..30],
      description: Faker::Company.catch_phrase
    )
  end
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user, new_user_attr) }
  let!(:group) do
    create(:group, owner: user.username) do |group|
      group.users << user_2
    end
  end
  let!(:group_without_users) { create(:group, owner: user.username) }

  # index action
  describe '#index' do
    context 'when user is not signed in' do
      before { get groups_path }
      it 'redirects the user to sign up page' do
        expect(response).to redirect_to users_path
      end
    end

    context 'when user is signed in' do
      before { sign_in user_2 }
      it 'returns users group\'s' do
        get groups_path
        expect(assigns(:groups).size).to eq user_2.groups.size
        expect(assigns(:groups)[0][:group].name).to eq user_2.groups[0].name
      end
    end
  end

  # show action
  describe '#show' do
    context 'when user is not signed in' do
      it 'redirects the user to sign up page' do
        get group_path(id: group.id)
        expect(response).to redirect_to users_path
      end
    end

    context 'when user is signed in' do
      before { sign_in user_2 }
      it 'redirects the user to the dashboard if group does not exist' do
        get group_path(id: 500)
        expect(response).to redirect_to groups_path
      end

      it 'redirects the user to the dashboard if user is not a group member' do
        get group_path(id: group_without_users.id)
        expect(response).to redirect_to groups_path
      end

      it 'loads the group message board if user is a group member' do
        get group_path(id: group.id)
        expect(response.body).to include "#{group.name} Message Board"
      end
    end
  end

  # new action
  describe '#new' do
    context 'when user is not signed in' do
      it 'redirects the user to sign up page' do
        get new_group_path
        expect(response).to redirect_to users_path
      end
    end

    context 'when user is signed in' do
      before { sign_in user }
      it 'returns a successful response' do
        get new_group_path
        expect(response.success?).to eq true
      end
    end
  end

  # create action
  describe '#create' do
    context 'when group params is incomplete' do
      before { sign_in user }
      it 'renders the new template' do
        post groups_path(group: {
          description: Faker::Company.catch_phrase
        })
        expect(response).to render_template("new")
      end
    end

    context 'when group params complete' do
      before { sign_in user }
      it 'creates the group and redirects to the group message board' do
        name = Faker::Company.unique.name[1..30]
        description = Faker::Company.catch_phrase
        post groups_path(group: {
          name: name,
          description: description
        })
        expect(response).to redirect_to group_path(id: Group.last.id)
        expect(Group.last.name).to eq name
        expect(Group.last.description).to eq description
      end
    end
  end
end

# https://devhints.io/factory_bot
# https://gist.github.com/eliotsykes/5b71277b0813fbc0df56
