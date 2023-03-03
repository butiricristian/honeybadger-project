class IsSpamNotificationService
  SPAM_TYPES = ['SpamNotification'].freeze
  SPAM_CODES = [512].freeze

  class << self
    def call(notification)
      return unless SPAM_TYPES.include?(notification['Type']) ||
                    SPAM_CODES.include?(notification['TypeCode'])

      true
    end
  end
end
