class ProductsController < SellersController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @q = current_user.products.ransack(params[:q])
    @q.sorts = 'updated_at desc' if @q.sorts.empty?

    @pagy, @products = pagy(@q.result)
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(product_params)

    if @product.save
      flash[:notice] = t('products.created')
      redirect_to @product
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @product.update(product_params)
      flash[:notice] = t('products.updated')
      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:notice] = t('products.destroyed')
    else
      flash[:alert] = t('errors.something_went_wrong')
    end

    redirect_to products_path
  end

  private

  def set_product
    @product = current_user.products.find_by(id: params[:id])

    return if @product.present?

    flash[:alert] = t('products.not_found')
    redirect_to products_path
  end

  def product_params
    params.require(:product).permit(:image, :name, :sku, :price, :quantity)
  end
end
