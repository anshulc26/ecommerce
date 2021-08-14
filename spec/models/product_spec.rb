require 'rails_helper'

# Test suite for the Product model
RSpec.describe Product, type: :model do
  # Association tests
  context "Association" do
    # ensure a product record belongs to a user record
    it { should belong_to(:user) }
  end

  # Validation tests
  context "Validation" do
    subject {
      build(:product, user: create(:seller))
    }

    # ensure columns user_id, name, sku, price, quantity are present before saving
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_presence_of(:sku) }
    it { should validate_length_of(:sku).is_at_most(255) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a user_id" do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a long name" do
      subject.name = FFaker::Lorem.characters(300)
      expect(subject).to_not be_valid
    end

    it "is not valid without a sku" do
      subject.sku = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a long sku" do
      subject.sku = FFaker::Lorem.characters(300)
      expect(subject).to_not be_valid
    end

    it "is not valid without a price" do
      subject.price = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a string price value" do
      subject.price = FFaker::Lorem.word
      expect(subject).to_not be_valid
    end

    it "is not valid without a quantity" do
      subject.quantity = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a string quantity value" do
      subject.quantity = FFaker::Lorem.word
      expect(subject).to_not be_valid
    end

    it "is not valid with a float quantity value" do
      subject.quantity = 100.1
      expect(subject).to_not be_valid
    end
  end

  # Scope tests
  context "Scope" do
    it "should return products with user's state" do
      create(:product, user: create(:seller))
      user = create(:user)
      expect(Product.of_state(user.state_code).length).to eq(1)
    end
  end
end
