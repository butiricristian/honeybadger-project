require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  describe 'POST /notifications/check-spam' do
    # Mock Slack web client instance
    let(:slack_client) { instance_double(Slack::Web::Client, chat_postMessage: true) }
    before(:each) do
      allow(Slack::Web::Client).to receive(:new).and_return(slack_client)
    end

    context 'successful' do
      context 'with spam notification' do
        let(:notification) do
          {
            "RecordType": 'Bounce',
            "Type": 'SpamNotification',
            "TypeCode": 512,
            "Name": 'Spam notification',
            "Tag": '',
            "MessageStream": 'outbound',
            "Description": 'The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.',
            "Email": 'zaphod@example.com',
            "From": 'notifications@honeybadger.io',
            "BouncedAt": '2023-02-27T21:41:30Z'
          }.with_indifferent_access
        end

        it 'should return success' do
          post notifications_check_spam_path, params: { notification:, format: :json }
          expect(response).to have_http_status(200)
        end

        it 'should call the slack client' do
          expect(slack_client).to receive(:chat_postMessage)
          post notifications_check_spam_path, params: { notification:, format: :json }
        end
      end

      context 'with non-spam notification' do
        let(:notification) do
          {
            "RecordType": "Bounce",
            "MessageStream": "outbound",
            "Type": "HardBounce",
            "TypeCode": 1,
            "Name": "Hard bounce",
            "Tag": "Test",
            "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
            "Email": "arthur@example.com",
            "From": "notifications@honeybadger.io",
            "BouncedAt": "2019-11-05T16:33:54.9070259Z",
          }.with_indifferent_access
        end

        it 'should return success' do
          post notifications_check_spam_path, params: { notification:, format: :json }
          expect(response).to have_http_status(200)
        end

        it 'should not call the slack client' do
          expect(slack_client).not_to receive(:chat_postMessage)
          post notifications_check_spam_path, params: { notification:, format: :json }
        end
      end
    end

    context 'unsuccessful' do
      context 'without notification' do
        it 'should return 400 Bad Request status' do
          post notifications_check_spam_path, params: { format: :json }
          expect(response).to have_http_status(400)
        end
      end

      context 'without type or type code of notification' do
        let(:notification) do
          {
            "RecordType": "Bounce",
            "MessageStream": "outbound",
            "Name": "Hard bounce",
            "Tag": "Test",
            "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
            "Email": "arthur@example.com",
            "From": "notifications@honeybadger.io",
            "BouncedAt": "2019-11-05T16:33:54.9070259Z",
          }.with_indifferent_access
        end

        it 'should return 400 Bad Request status' do
          post notifications_check_spam_path, params: { notification:, format: :json }
          expect(response).to have_http_status(400)
        end
      end
    end
  end
end
