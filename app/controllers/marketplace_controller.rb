class MarketplaceController < BuyersController
  def index
    @q = Product.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?

    @pagy, @products = pagy(@q.result.includes(:user).of_state(current_user.state_code), items: 15)
  end
end
