require 'rails_helper'

RSpec.feature MarketplaceController, type: :feature do
  let!(:buyer) { create(:user) }
  let!(:product) { create(:product, user: create(:seller)) }

  before do
    sign_in(buyer)
    visit marketplace_path
  end

  scenario 'display products in marketplace' do
    expect(page).to have_content(I18n.t('global.marketplace'))
    expect(page).to have_css('div.card')
    expect(page).to have_css('div.card-body')
    expect(page).to have_css('img.card-img-top')
    expect(page).to have_css('div.card-footer')

    expect(page).to have_css("h5.card-title", text: product.name)
    expect(page).to have_css("li.list-group-item", text: product.sku)
    expect(page).to have_css("li.list-group-item", text: product.price)
    expect(page).to have_css("li.list-group-item", text: product.quantity)
  end
end
