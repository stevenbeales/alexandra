require 'rails_helper'

RSpec.describe Handlers::IntentRequestHandlers::ListIntentRequestHandler do

  describe ".process" do

    let!(:user) { User.create(amazon_user_id: 'sample_user_id') }

    let!(:item1) do
      Item.create(
        name: 'Item 1',
        created_at: Time.now
      )
    end

    let!(:item2) do
      Item.create(
        name: 'Item 2',
        created_at: Time.now,
        user_id: user.id
      )
    end

    context 'when initialized with a context containing a AllItems Intent' do
      let(:intent) do
        { 'name' => 'AllItems' }
      end

      let(:context) { double('Context', user_id: user.id, intent: intent, dialog_state: nil) }

      subject { Handlers::IntentRequestHandlers::ListIntentRequestHandler.new(context) }

      it "correctly returns an appropriate JSON response" do
        response = JSON.parse subject.process

        expect(response['version']).to eq '1.0'
        expect(response['response']['outputSpeech']['text']).to eq 'TBD'
        expect(response['response']['card']['title']).to eq 'TBD'
        expect(response['response']['card']['content']).to eq (
          "TBD on #{Time.now.strftime('%a, %B %d')}"
        )
        expect(response['response']['reprompt']['outputSpeech']['text']).to eq 'Is there anything else I can help you with?'
      end
    end
  end
end
