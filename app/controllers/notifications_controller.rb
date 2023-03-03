class NotificationsController < ActionController::API
  class MissingFieldsInBodyError < StandardError; end

  def check_spam
    validate_notification
  rescue ActionController::ParameterMissing => e
    render json: { message: "An error occurred: #{e.full_message}" }, status: :bad_request
  rescue MissingFieldsInBodyError => e
    render json: { message: "Some fields are missing: #{e.full_message}" }, status: :bad_request
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
end
