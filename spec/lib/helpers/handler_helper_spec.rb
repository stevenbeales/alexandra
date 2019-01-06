require 'rails_helper'

RSpec.describe Helpers::HandlerHelper do

  describe ".create_message_response" do
    it "returns a correctly formatted response object" do
      response = Helpers::HandlerHelper.create_message_response(
        message: 'This is a test response',
        card: {
          type: 'Simple',
          title: 'Title',
          content: 'Content!'
        },
        session_attributes: { session_attribute_key: :session_attribute_value },
        reprompt: 'Sample reprompt',
        end_session: false
      )

      expect(JSON.parse(response)['response']['outputSpeech']['text']).to eq 'This is a test response'
      expect(JSON.parse(response)['sessionAttributes']).to include('session_attribute_key' => 'session_attribute_value')
      expect(JSON.parse(response)['response']['shouldEndSession']).to eq false
      expect(JSON.parse(response)['response']['card']['type']).to eq 'Simple'
      expect(JSON.parse(response)['response']['card']['title']).to eq 'Title'
      expect(JSON.parse(response)['response']['card']['content']).to eq 'Content!'
      expect(JSON.parse(response)['response']['reprompt']['outputSpeech']['text']).to eq 'Sample reprompt'
    end
  end

  describe ".create_delegate_response" do
    it "returns a correctly formatted response object" do
      response = Helpers::HandlerHelper.create_delegate_response(
        intent: { "name"=>"Add",
                  "confirmationStatus"=>"NONE",
                  "slots"=> {
                    "item_A"=> {
                      "name"=>"item_A",
                      "value"=>"TBD",
                      "confirmationStatus"=>"NONE"
                    }
                  }
                },
        session_attributes: { session_attribute_key: :session_attribute_value }
      )

      expect(JSON.parse(response)['response']['directives'][0]['type']).to eq 'Dialog.Delegate'
      expect(JSON.parse(response)['sessionAttributes']).to include('session_attribute_key' => 'session_attribute_value')
      expect(JSON.parse(response)['response']['shouldEndSession']).to eq false
    end
  end

  let!(:items) do
    items = []
    items << Item.create(
      name: 'Item1'
    )
    items << Item.create(
      name: 'Item2'
    )
  end

  describe ".prepare_items_for_message" do
    it "returns a correctly formatted string" do
      message = Helpers::HandlerHelper.prepare_items_for_message items
      expect(message).to eq '1 Item1 and 2 Item2'
    end
  end

  describe ".prepare_items_for_card_with_date" do
    it "returns a correctly formatted string" do
      message = Helpers::HandlerHelper.prepare_items_for_card_with_date items
      expect(message).to eq "1 Item1 added on Mon, July 17\n2 Item2 added on Mon, July 17"
    end
  end

  describe ".prepare_items_for_card_without_date" do
    it "returns a correctly formatted string" do
      message = Helpers::HandlerHelper.prepare_items_for_card_without_date items
      expect(message).to eq "1 Item1\n2 Item2"
    end
  end

end
