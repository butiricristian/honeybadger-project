class NotificationsController < ActionController::API
  class MissingFieldsInBodyError < StandardError; end

  def check_spam
    validate_notification
    send_slack_message if is_spam_notification
  rescue ActionController::ParameterMissing => e
    render json: { message: "Some parameters are missing: #{e.message}" }, status: :bad_request
  rescue MissingFieldsInBodyError => e
    render json: { message: "Some fields are missing: #{e.message}" }, status: :bad_request
  end

  private

  def notification
    @notification ||= params.require(:notification)
  end

  def validate_notification
    # Spam messages cannot be determined without Type or TypeCode
    return unless notification['Type'].blank? || notification['TypeCode'].blank?

    raise MissingFieldsInBodyError, 'Type and TypeCode fields are missing'
  end

  def is_spam_notification
    IsSpamNotificationService.call(notification)
  end

  def send_slack_message
    client = Slack::Web::Client.new
    client.chat_postMessage(
      channel: '#honeybadger-test-application',
      text: spam_notification_text
    )
  end

  def spam_notification_text
    text = ["Spam Notification Received: #{notification['Name']}"]
    text << "email: #{notification['Email']}"
    text << "description: #{notification['Description']}"
    text.join("\n")
  end
end
