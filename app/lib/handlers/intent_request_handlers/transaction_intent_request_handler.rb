module Handlers
  module IntentRequestHandlers

    class TransactionIntentRequestHandler < BaseRequestHandler

      def process
        if dialog_state.nil? || dialog_state != 'COMPLETED'
          Helpers::HandlerHelper.create_delegate_response(intent: intent)
        elsif intent['confirmationStatus'] == 'CONFIRMED'
          send(get_intent_specific_method(intent['name']))
        else
          Helpers::HandlerHelper.create_message_response(
            message: "Action canceled, is there anything else I can help you with?",
            end_session: false
          )
        end
      end

      private

      def items
        @items ||= get_items_from_slots
      end

      def slots
        @slots ||= intent['slots'].to_h
      end

      def get_intent_specific_method(intent_name)
        {
          'Add'     => :process_add_items,
          'Remove'  => :process_remove_items,
          'Clear'   => :process_clear_items
        }[intent_name]
      end

      def process_add_items
        Helpers::HandlerHelper.create_message_response(
          message: "#{prepare_transaction_items_for_message(added_items)} were added",
          card: {
            type: 'Simple',
            title: 'TBD',
            content: Helpers::HandlerHelper.prepare_items_for_card_without_date(added_items)
          },
          reprompt: 'Is there anything else I can help you with?',
          end_session: false
        )
      end

      def process_remove_items
        Helpers::HandlerHelper.create_message_response(
          message: "#{prepare_transaction_items_for_message(removed_items)} were removed",
          card: {
            type: 'Simple',
            title: 'Removed Items',
            content: prepare_removed_items_for_card(removed_items)
          },
          reprompt: 'Is there anything else I can help you with?',
          end_session: false
        )
      end

      def process_clear_items
        Item.owned_by(user_id).delete_all
        Helpers::HandlerHelper.create_message_response(
          message: "All items have been removed",
          reprompt: 'Is there anything else I can help you with?',
          end_session: false
        )
      end

      def added_items
        @added_items ||= items.map do |k|
          item = Item.new(
            name: k
          )
          item.tap(&:save)
        end
      end

      def removed_items
        @removed_items ||= items.map do |k|
          remove_helper = Helpers::RemoveItemHelper.new(name: k)
          remove_helper.remove!
        end
      end
    end  
  end
end
