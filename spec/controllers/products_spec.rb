require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'before actions' do
    describe 'authenticate_user!' do
      it 'is expected to define before action' do
        is_expected.to use_before_action(:authenticate_user!)
      end
    end

    describe 'authenticate_seller!' do
      it 'is expected to define before action' do
        is_expected.to use_before_action(:authenticate_seller!)
      end
    end

    describe 'set_product' do
      it 'is expected to define before action' do
        is_expected.to use_before_action(:set_product)
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

    it 'is expected to redirect to the root page if buyer is signed in' do
      sign_in buyer
      get :index
      expect(response).to redirect_to(root_path)
    end

    context 'when seller is logged in' do
      before do
        sign_in seller
        get :index
      end

      it 'is expected to assign products instance variable' do
        create(:product, user: seller)
        expect(assigns[:products]).to eq(seller.products)
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

  # new action
  describe 'GET #new' do
    let(:buyer) { create(:user) }
    let(:seller) { create(:seller) }

    it 'is expected to redirect to the sign in page if user is not signed in' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'is expected to redirect to the root page if buyer is signed in' do
      sign_in buyer
      get :new
      expect(response).to redirect_to(root_path)
    end

    context 'when seller is logged in' do
      before do
        sign_in seller
        get :new
      end

      it 'is expected to assign product as new instance variable' do
        expect(assigns[:product]).to be_instance_of(Product)
      end

      it "returns a 200" do
        expect(response).to have_http_status(:ok)
      end

      it 'renders new template' do
        is_expected.to render_template(:new)
      end

      it 'renders application layout' do
        is_expected.to render_template(:application)
      end
    end
  end

  # create action
  describe 'POST #create' do
    let(:buyer) { create(:user) }
    let(:seller) { create(:seller) }

    it 'is expected to redirect to the sign in page if user is not signed in' do
      post :create
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'is expected to redirect to the root page if buyer is signed in' do
      sign_in buyer
      post :create
      expect(response).to redirect_to(root_path)
    end

    context 'when seller is logged in' do
      before do
        sign_in seller
        post :create, params: params
      end

      context 'when params are empty' do
        let(:params) { { product: { name: '', sku: '', price: '', quantity: '' } } }

        it 'is expected to render new template' do
          is_expected.to render_template(:new)
        end

        it 'is expected to add errors to name, sku, price, quantity attribute' do
          expect(assigns[:product].errors[:name]).to eq(["can't be blank"])
          expect(assigns[:product].errors[:sku]).to eq(["can't be blank"])
          expect(assigns[:product].errors[:price]).to eq(["can't be blank", 'is not a number'])
          expect(assigns[:product].errors[:quantity]).to eq(["can't be blank", 'is not a number'])
        end
      end

      context 'when params are invalid' do
        let(:params) { { product: { name: FFaker::Lorem.word, sku: '', price: FFaker::Lorem.word, quantity: FFaker::Lorem.word } } }

        it 'is expected to render new template' do
          is_expected.to render_template(:new)
        end

        it 'is expected to add errors to price, quantity attribute' do
          expect(assigns[:product].errors[:sku]).to eq(["can't be blank"])
          expect(assigns[:product].errors[:price]).to eq(['is not a number'])
          expect(assigns[:product].errors[:quantity]).to eq(['is not a number'])
        end
      end

      context 'when params are correct' do
        let(:params) { { product: { name: 'Name', sku: 'Sku', price: 100, quantity: 1000 } } }

        it 'is expected to create new product successfully' do
          expect(assigns[:product]).to be_instance_of(Product)
        end

        it 'is expected to have values assigned to it' do
          expect(assigns[:product].name).to eq('Name')
          expect(assigns[:product].sku).to eq('Sku')
          expect(assigns[:product].price).to eq(100.0)
          expect(assigns[:product].quantity).to eq(1000)
        end

        it 'is expected to redirect to products path' do
          is_expected.to redirect_to product_path(assigns[:product])
        end

        it 'is expected to set flash message' do
          expect(flash[:notice]).to eq(I18n.t('products.created'))
        end
      end
    end
  end

  # show action
  describe 'GET #show' do
    let(:buyer) { create(:user) }
    let(:seller) { create(:seller) }

    it 'is expected to redirect to the sign in page if user is not signed in' do
      get :show, params: { id: 999 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'is expected to redirect to the root page if buyer is signed in' do
      sign_in buyer
      get :show, params: { id: 999 }
      expect(response).to redirect_to(root_path)
    end

    context 'when seller is logged in' do
      before do
        sign_in seller
        get :show, params: params
      end

      context 'when product id is invalid' do
        let(:params) { { id: 999 } }

        it 'is expected to redirect_to products path' do
          is_expected.to redirect_to(products_path)
        end

        it 'is expected to set flash' do
          expect(flash[:alert]).to eq(I18n.t('products.not_found'))
        end
      end

      context 'when product id is valid but it belongs to different seller' do
        let(:product) { create(:product, user: create(:seller)) }
        let(:params) { { id: product.id } }

        it 'is expected to redirect_to products path' do
          is_expected.to redirect_to(products_path)
        end

        it 'is expected to set flash' do
          expect(flash[:alert]).to eq(I18n.t('products.not_found'))
        end
      end

      context 'when product id is valid' do
        let(:product) { create(:product, user: seller) }
        let(:params) { { id: product.id } }

        it 'is expected to set product instance variable' do
          expect(assigns[:product].id).to eq(product.id)
        end

        it "returns a 200" do
          expect(response).to have_http_status(:ok)
        end

        it 'is expected to render show template' do
          is_expected.to render_template(:show)
        end

        it 'renders application layout' do
          is_expected.to render_template(:application)
        end
      end
    end
  end

  # edit action
  describe 'GET #edit' do
    let(:buyer) { create(:user) }
    let(:seller) { create(:seller) }

    it 'is expected to redirect to the sign in page if user is not signed in' do
      get :edit, params: { id: 999 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'is expected to redirect to the root page if buyer is signed in' do
      sign_in buyer
      get :edit, params: { id: 999 }
      expect(response).to redirect_to(root_path)
    end

    context 'when seller is logged in' do
      before do
        sign_in seller
        get :edit, params: params
      end

      context 'when product id is invalid' do
        let(:params) { { id: 999 } }

        it 'is expected to redirect_to products path' do
          is_expected.to redirect_to(products_path)
        end

        it 'is expected to set flash' do
          expect(flash[:alert]).to eq(I18n.t('products.not_found'))
        end
      end

      context 'when product id is valid but it belongs to different seller' do
        let(:product) { create(:product, user: create(:seller)) }
        let(:params) { { id: product.id } }

        it 'is expected to redirect_to products path' do
          is_expected.to redirect_to(products_path)
        end

        it 'is expected to set flash' do
          expect(flash[:alert]).to eq(I18n.t('products.not_found'))
        end
      end

      context 'when product id is valid' do
        let(:product) { create(:product, user: seller) }
        let(:params) { { id: product.id } }

        it 'is expected to set product instance variable' do
          expect(assigns[:product].id).to eq(product.id)
        end

        it "returns a 200" do
          expect(response).to have_http_status(:ok)
        end

        it 'is expected to render edit template' do
          is_expected.to render_template(:edit)
        end

        it 'renders application layout' do
          is_expected.to render_template(:application)
        end
      end
    end
  end

  # update action
  describe 'PATCH #update' do
    let(:buyer) { create(:user) }
    let(:seller) { create(:seller) }

    it 'is expected to redirect to the sign in page if user is not signed in' do
      patch :update, params: { id: 999 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'is expected to redirect to the root page if buyer is signed in' do
      sign_in buyer
      patch :update, params: { id: 999 }
      expect(response).to redirect_to(root_path)
    end

    context 'when seller is logged in' do
      before do
        sign_in seller
        patch :update, params: params
      end

      context 'when product id is invalid' do
        let(:params) { { id: 999 } }

        it 'is expected to redirect_to products path' do
          is_expected.to redirect_to(products_path)
        end

        it 'is expected to set flash' do
          expect(flash[:alert]).to eq(I18n.t('products.not_found'))
        end
      end

      context 'when product id is valid but it belongs to different seller' do
        let(:product) { create(:product, user: create(:seller)) }
        let(:params) { { id: product.id } }

        it 'is expected to redirect_to products path' do
          is_expected.to redirect_to(products_path)
        end

        it 'is expected to set flash' do
          expect(flash[:alert]).to eq(I18n.t('products.not_found'))
        end
      end

      context 'when params are empty' do
        let(:product) { create(:product, user: seller) }
        let(:params) { { id: product.id, product: { name: '', sku: '', price: '', quantity: '' } } }

        it 'is expected to render edit template' do
          is_expected.to render_template(:edit)
        end

        it 'is expected not to update product attributes' do
          expect(product.reload.name).not_to be_blank
          expect(product.reload.sku).not_to be_blank
          expect(product.reload.price).not_to be_blank
          expect(product.reload.quantity).not_to be_blank
        end

        it 'is expected to add errors to name, sku, price, quantity attribute' do
          expect(assigns[:product].errors[:name]).to eq(["can't be blank"])
          expect(assigns[:product].errors[:sku]).to eq(["can't be blank"])
          expect(assigns[:product].errors[:price]).to eq(["can't be blank", 'is not a number'])
          expect(assigns[:product].errors[:quantity]).to eq(["can't be blank", 'is not a number'])
        end
      end

      context 'when params are invalid' do
        let(:product) { create(:product, user: seller) }
        let(:params) { { id: product.id, product: { name: FFaker::Lorem.word, sku: '', price: FFaker::Lorem.word, quantity: FFaker::Lorem.word } } }

        it 'is expected to render edit template' do
          is_expected.to render_template(:edit)
        end

        it 'is expected not to update product attributes' do
          expect(product.reload.name).to eq(product.name)
          expect(product.reload.sku).to eq(product.sku)
          expect(product.reload.price).to eq(product.price)
          expect(product.reload.quantity).to eq(product.quantity)
        end

        it 'is expected to add errors to price, quantity attribute' do
          expect(assigns[:product].errors[:sku]).to eq(["can't be blank"])
          expect(assigns[:product].errors[:price]).to eq(['is not a number'])
          expect(assigns[:product].errors[:quantity]).to eq(['is not a number'])
        end
      end

      context 'when params are correct' do
        let(:product) { create(:product, user: seller) }
        let(:params) { { id: product.id, product: { name: 'Name1', sku: 'Sku1', price: 10, quantity: 100 } } }

        it 'is expected to update product' do
          expect(product.reload.name).to eq('Name1')
          expect(product.reload.sku).to eq('Sku1')
          expect(product.reload.price).to eq(10.0)
          expect(product.reload.quantity).to eq(100)
        end

        it 'is expected to redirect to products path' do
          is_expected.to redirect_to product_path(assigns[:product])
        end

        it 'is expected to set flash message' do
          expect(flash[:notice]).to eq(I18n.t('products.updated'))
        end
      end
    end
  end

  # destroy action
  describe 'DELETE #destroy' do
    let(:buyer) { create(:user) }
    let(:seller) { create(:seller) }

    it 'is expected to redirect to the sign in page if user is not signed in' do
      delete :destroy, params: { id: 999 }
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'is expected to redirect to the root page if buyer is signed in' do
      sign_in buyer
      delete :destroy, params: { id: 999 }
      expect(response).to redirect_to(root_path)
    end

    context 'when seller is logged in' do
      before do
        sign_in seller
        delete :destroy, params: params
      end

      context 'when product id is invalid' do
        let(:params) { { id: 999 } }

        it 'is expected to redirect_to products path' do
          is_expected.to redirect_to(products_path)
        end

        it 'is expected to set flash' do
          expect(flash[:alert]).to eq(I18n.t('products.not_found'))
        end
      end

      context 'when product id is valid but it belongs to different seller' do
        let(:product) { create(:product, user: create(:seller)) }
        let(:params) { { id: product.id } }

        it 'is expected to redirect_to products path' do
          is_expected.to redirect_to(products_path)
        end

        it 'is expected to set flash' do
          expect(flash[:alert]).to eq(I18n.t('products.not_found'))
        end
      end

      context 'when product id is valid' do
        let(:product) { create(:product, user: seller) }
        let(:params) { { id: product.id } }

        it 'is expected to redirect to products path' do
          is_expected.to redirect_to products_path
        end

        it 'is expected to set flash message' do
          expect(flash[:notice]).to eq(I18n.t('products.destroyed'))
        end
      end
    end
  end
end
