class NotificationsController < ActionController::API
  def check_spam
    notification
  end

  private

  def notification
    @notification ||= params.require(:notification)
  rescue ActionController::ParameterMissing => e
    render json: { message: "An error occurred: #{e.full_message}" }, status: :bad_request
  end
end
