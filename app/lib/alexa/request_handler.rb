module Alexa

  class RequestHandler

    attr_reader :request, :user_id, :dialog_state
    def initialize(params)
      @request = AlexaRubykit.build_request params
      @user_id = User.find_or_create_by(amazon_user_id: request.session.user['userId']).id
      @dialog_state = request.dialog_state
    end

    def process
        handler = handler_for(request.type).new(self)
        handler.process
    end

    private

    def handler_for(request_type)
      {
        'INTENT_REQUEST'        => Handlers::IntentRequestHandler,
        'LAUNCH_REQUEST'        => Handlers::LaunchRequestHandler,
        'SESSION_ENDED_REQUEST' => Handlers::SessionEndedRequestHandler
      }[request_type]
    end

  end

end
