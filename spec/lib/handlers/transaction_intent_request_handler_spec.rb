require 'rails_helper'

RSpec.describe Handlers::IntentRequestHandlers::TransactionIntentRequestHandler do

  describe ".process" do

    let!(:user) { User.create(amazon_user_id: 'sample_user_id') }

    context 'when initialized with a context containing an Add Intent' do
      let(:intent) do
        {
          'name' => 'Add',
          'confirmationStatus' => 'CONFIRMED',
          'slots' => {
            'item_A' => {
              'name' => 'item_A',
              'value' => 'TBD'
            },
            'item_B' => {
              'name' => 'item_B',
              'value' => nil
            },
            'item_C' => {
              'name' => 'item_C',
              'value' => nil
            },
            'item_D' => {
              'name' => 'item_D',
              'value' => nil
            },
            'item_E' => {
              'name' => 'item_E',
              'value' => nil
            }
          }
        }
      end

      let(:context) { double('Context', user_id: user.id, intent: intent, dialog_state: 'COMPLETED') }

      subject { Handlers::IntentRequestHandlers::TransactionIntentRequestHandler.new(context) }

      it "correctly returns an appropriate JSON response" do
        response = JSON.parse subject.process

        expect(response['version']).to eq '1.0'
        expect(response['response']['outputSpeech']['text']).to eq 'TBD'
        expect(response['response']['card']['title']).to eq 'TBD'
        expect(response['response']['card']['content']).to eq 'TBD'
        expect(response['response']['reprompt']['outputSpeech']['text']).to eq 'Is there anything else I can help you with?'
      end
    end

    context 'when initialized with a context containing a Remove Intent' do
      let(:intent) do
        {
          'name' => 'Remove',
          'confirmationStatus' => 'CONFIRMED',
          'slots' => {
            'item_A' => {
              'name' => 'item_A',
              'value' => 'TBD'
            },
            'item_B' => {
              'name' => 'item_B',
              'value' => nil
            },
            'item_C' => {
              'name' => 'item_C',
              'value' => nil
            },
            'item_D' => {
              'name' => 'item_D',
              'value' => nil
            },
            'item_E' => {
              'name' => 'item_E',
              'value' => nil
            }
          }
        }
      end

      context "with the requested item present in the database" do

        let!(:item) do
          Item.create(
            name: 'TBD',
          )
        end

        it "correctly returns an appropriate JSON response" do
          response = JSON.parse subject.process

          expect(response['version']).to eq '1.0'
          expect(response['response']['outputSpeech']['text']).to eq 'TBD'
          expect(response['response']['card']['title']).to eq 'TBD'
          expect(response['response']['card']['content']).to eq 'TBD'
          expect(response['response']['reprompt']['outputSpeech']['text']).to eq 'Is there anything else I can help you with?'
        end

      end
    end
  end
end
