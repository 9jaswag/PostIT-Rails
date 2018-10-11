require 'rails_helper'

RSpec.describe 'User Mailer', type: :mailer do
  let!(:user) { create(:user, reset_token: Faker::Code.nric) }
  let!(:group) { create(:group, owner: user.username) }
  let!(:account_activation_mail) { UserMailer.account_activation user }
  let!(:password_reset_mail) { UserMailer.password_reset user }
  let!(:message) { create(:message, group_id: group.id, user_id: user.id) }
  let!(:email_notification_mail) { UserMailer.email_notification(user, message) }

  # account_activation mailer
  describe '#account_activation' do
    it 'renders the headers' do
      expect(account_activation_mail.subject).to eq('Account Activation')
      expect(account_activation_mail.to[0]).to eq(user.email)
      expect(account_activation_mail.from[0]).to eq('noreply@postit.herokuapp.com')
    end

    it 'renders the body' do
      expect(account_activation_mail.body.encoded).to include 'Click the link below to activate your account.'
    end
  end

  # password_reset mailer
  describe '#password_reset' do
    it 'renders the headers' do
      expect(password_reset_mail.subject).to eq('PostIT password reset')
      expect(password_reset_mail.to[0]).to eq(user.email)
      expect(password_reset_mail.from[0]).to eq('noreply@postit.herokuapp.com')
    end

    it 'renders the body' do
      expect(password_reset_mail.body.encoded).to include 'To reset your password click the link below:'
    end
  end

  # email_notification mailer
  describe '#email_notification' do
    it 'renders the headers' do
      expect(email_notification_mail.subject).to eq('PostIT notification')
      expect(email_notification_mail.to[0]).to eq(user.email)
      expect(email_notification_mail.from[0]).to eq('noreply@postit.herokuapp.com')
    end

    it 'renders the body' do
      expect(email_notification_mail.body.encoded).to include "You have a #{message.priority} message on PostIT"
    end
  end
end
