module Handlers
  module IntentRequestHandlers

    class BaseRequestHandler

      attr_reader :intent, :user_id, :dialog_state
      def initialize(context)
        @intent = context.intent
        @user_id = context.user_id
        @dialog_state = context.dialog_state
      end

    end

  end
end
