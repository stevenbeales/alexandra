require 'rails_helper'

RSpec.describe Item, type: :model do

  let!(:user) do
    User.create(amazon_user_id: 'testAmazonUserID')
  end

  subject do
    Item.create(
      name: 'TBD'
    )
  end

  it { should validate_presence_of :name }

  describe "#to_s" do
    it "returns the item's name" do
      expect(subject.to_s).to eql 'TBD'
    end
  end

end
