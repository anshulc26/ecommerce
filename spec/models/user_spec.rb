require 'rails_helper'

# Test suite for the User model
RSpec.describe User, type: :model do
  # Association tests
  context "Association" do
    # ensure User model has a 1:m relationship with the Product model
    it { should have_many(:products).dependent(:destroy) }
  end

  # Validation tests
  context "Validation" do
    subject {
      build(:user)
    }

    # ensure columns user_type, name, email, password, state_code are present before saving
    it { should validate_presence_of(:user_type) }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_presence_of(:state_code) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a user_type" do
      subject.user_type = nil
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

    it "is not valid without a email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a short password" do
      subject.password = FFaker::Lorem.characters(4)
      expect(subject).to_not be_valid
    end

    it "is not valid without a state_code" do
      subject.state_code = nil
      expect(subject).to_not be_valid
    end
  end
end
