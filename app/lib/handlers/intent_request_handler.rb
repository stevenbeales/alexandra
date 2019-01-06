module Handlers

  class IntentRequestHandler

    attr_reader :intent, :user_id, :dialog_state
    def initialize(context)
      @intent = context.request.intent
      @user_id = context.user_id
      @dialog_state = context.dialog_state
    end
    
    def handler
      @handler ||= handler_for(intent['name']).new(self)
    end

    def process
      handler.process
    end

    private

    def handler_for(intent)
      {
        'Add'           => Handlers::IntentRequestHandlers::TransactionIntentRequestHandler,
        'Remove'        => Handlers::IntentRequestHandlers::TransactionIntentRequestHandler,
        'Clear'         => Handlers::IntentRequestHandlers::TransactionIntentRequestHandler,
        'AllItems'      => Handlers::IntentRequestHandlers::ListIntentRequestHandler
      }[intent]
    end

  end

end
