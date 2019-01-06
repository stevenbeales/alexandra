require 'rails_helper'

RSpec.describe Handlers::SessionEndedRequestHandler do

  describe ".process" do

    subject { Handlers::SessionEndedRequestHandler.new(nil) }

    it "returns a nil reponse" do
      response = subject.process

      expect(response).to eq nil
    end

  end

end
