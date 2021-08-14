require 'rails_helper'

RSpec.describe MarketplaceController, type: :controller do
  describe 'before actions' do
    describe 'authenticate_user!' do
      it 'is expected to define before action' do
        is_expected.to use_before_action(:authenticate_user!)
      end
    end

    describe 'authenticate_buyer!' do
      it 'is expected to define before action' do
        is_expected.to use_before_action(:authenticate_buyer!)
      end
    end

  end

  # index action
  describe 'GET #index' do
    let(:buyer) { create(:user) }
    let(:seller) { create(:seller) }

    it 'is expected to redirect to the sign in page if user is not signed in' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'is expected to redirect to the root page if seller is signed in' do
      sign_in seller
      get :index
      expect(response).to redirect_to(root_path)
    end

    context 'when buyer is logged in' do
      before do
        sign_in buyer
        get :index
      end

      it 'is expected to assign products instance variable' do
        # create products for the seller with same state as buyer i.e AK - Alaska
        create_list(:product, 5, user: seller)
        # create products for the seller with different state as buyer
        create_list(:product, 5, user: create(:seller, state_code: 'AL'))

        expect(assigns[:products].count).to eq(5)
      end

      it "returns a 200" do
        expect(response).to have_http_status(:ok)
      end

      it 'renders index template' do
        is_expected.to render_template(:index)
      end

      it 'renders application layout' do
        is_expected.to render_template(:application)
      end
    end
  end
end
