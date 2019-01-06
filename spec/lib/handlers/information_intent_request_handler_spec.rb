require 'rails_helper'

RSpec.describe Handlers::IntentRequestHandlers::TransactionIntentRequestHandler do

  describe ".process" do
    let!(:user) { User.create(amazon_user_id: 'sample_user_id') }
  end
end
