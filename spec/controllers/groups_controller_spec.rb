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
  let!(:unactivated_user_attr) do
    attributes_for(
      :user,
      username: Faker::Name.unique.first_name[1..6],
      email: Faker::Internet.unique.email,
      phone: '23456789012',
      activated: false
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
  let!(:unactivated_user) { create(:user, unactivated_user_attr) }
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

  # search action
  describe '#search' do
    context 'when user is not activated' do
      before { sign_in user }
      it 'does not return the user' do
        get users_search_path(username: unactivated_user.username, group_id: group.id ), xhr: true
        expect(response.content_type) == :js
        expect(response.body).to include "User not found"
      end
    end

    context 'when user is activated' do
      before { sign_in user }
      it 'returns the user if the user belongs to the group' do
        get users_search_path(username: user_2.username, group_id: group.id ), xhr: true
        expect(response.content_type) == :js
        expect(response.body).to include "@#{user_2.username}"
        expect(response.body).to include "Click to remove"
      end

      it 'returns a button to add the user if the user does not belongs to the group' do
        get users_search_path(username: user.username, group_id: group.id ), xhr: true
        expect(response.content_type) == :js
        expect(response.body).to include "@#{user.username}"
        expect(response.body).to include "Click to add"
      end
    end
  end

  # add_member action
  describe '#add_member' do
    context 'when user exists' do
      before { sign_in user }
      it 'does not add the user to the group if user is already a member' do
        post groups_add_member_path(group_id: group.id, user_id: user_2.id), xhr: true
        expect(response.body).to include "User is already a group member"
      end

      it 'adds the user to the group if user is not a member' do
        post groups_add_member_path(group_id: group.id, user_id: user.id), xhr: true
        expect(response.body).to include "User has been added to group"
      end
    end

    # context 'when user does not exists' do
    #   before { sign_in user }
    #   it 'renders the show template' do
    #     post groups_add_member_path(group_id: group.id, user_id: 1000), xhr: true
    #     binding.pry
    #     expect(response).to render_template("show")
    #   end
    # end
  end

  # remove member action
  describe '#remove_member' do
    context 'when user is not group owner' do
      before { sign_in user_2 }
      it 'does not remove the member' do
        delete groups_remove_member_path(group_id: group.id, user_id: user_2.id), xhr: true
        expect(response.body).to include "Why you wanna do like that?"
      end
    end

    context 'when user is group owner' do
      before do
        sign_in user
        add_to_group(group, user)
      end

      it 'does not remove the member if member is group owner' do
        delete groups_remove_member_path(group_id: group.id, user_id: user.id), xhr: true
        expect(response.body).to include "You cant leave your group"
      end

      it 'does removes the user' do
        delete groups_remove_member_path(group_id: group.id, user_id: user_2.id), xhr: true
        expect(response.body).to include "User has been removed from group"
      end
    end
  end
end

# https://devhints.io/factory_bot
# https://gist.github.com/eliotsykes/5b71277b0813fbc0df56
