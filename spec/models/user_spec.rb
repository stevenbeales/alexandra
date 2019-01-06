require 'rails_helper'

RSpec.describe User, type: :model do

  subject { User.create(amazon_user_id: "testAmazonUserID") }

    it { should have_many(:items) }

    it { should validate_presence_of :amazon_user_id }

    it { should validate_uniqueness_of :amazon_user_id }

    describe "#to_s" do
      it "returns the user's amazon_user_id" do
        expect(subject.to_s).to eql "testAmazonUserID"
      end
    end

end
