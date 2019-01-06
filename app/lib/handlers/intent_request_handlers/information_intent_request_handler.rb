module Handlers
  module IntentRequestHandlers

    class InformationIntentRequestHandler < BaseRequestHandler

      def process
        send(get_intent_specific_method(intent['name']))
      end

      private

      def get_intent_specific_method(intent_name)
        {
          'GetExpiration' => :process_get_expiration
        }[intent_name]
      end

      def item
        @item ||= intent['slots']['item']['value']
      end


      def message
        "TBD"
      end

      def process_get_expiration
        Helpers::HandlerHelper.create_message_response(
          message: message,
          card: {
            type: 'Simple',
            title: item.to_s,
            content: message
          },
          reprompt: 'Is there anything else I can help you with?',
          end_session: false
        )
      end

    end

  end
end
