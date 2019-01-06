module Handlers

  class LaunchRequestHandler

    def initialize(context)
      # Stub
    end

    def process
      Helpers::HandlerHelper.create_message_response(
        message: 'What can Alexandra do for you?',
        end_session: false
      )
    end

  end

end
