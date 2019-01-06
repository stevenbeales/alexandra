require 'rails_helper'

RSpec.describe Handlers::LaunchRequestHandler do

  describe ".process" do

    subject { Handlers::LaunchRequestHandler.new(nil) }

    it "returns a correctly formatted JSON response, starting a new Alexa session" do
      response = JSON.parse subject.process

      expect(response['version']).to eq '1.0'
      expect(response['response']['outputSpeech']['text']).to eql 'What can Alexandra do for you?'
      expect(response['response']['shouldEndSession']).to eql false
    end

  end

end
