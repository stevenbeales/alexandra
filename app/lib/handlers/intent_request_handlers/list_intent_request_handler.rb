module Handlers
  module IntentRequestHandlers

    class ListIntentRequestHandler < BaseRequestHandler

      def process
        send(get_intent_specific_method(intent['name']))
      end

      private

      def get_intent_specific_method(intent_name)
        {
          'AllItems'      => :process_all_items
        }[intent_name]
      end

      def process_all_items
        Helpers::HandlerHelper.create_message_response(
          message: message_for_all_items(items),
          card: {
            type: 'Simple',
            title: 'TBD',
            content: Helpers::HandlerHelper.prepare_items_for_card_with_date(items)
          },
          reprompt: 'Is there anything else I can help you with?',
          end_session: false
        )
      end
    end
  end
end
