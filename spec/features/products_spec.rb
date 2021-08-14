require 'rails_helper'

RSpec.feature ProductsController, type: :feature do
  let!(:seller) { create(:seller) }
  let!(:product) { create(:product, user: seller) }

  before do
    sign_in(seller)
    visit products_path
  end

  scenario 'display products and create new product button' do
    expect(page).to have_content(I18n.t('products.heading'))
    expect(page).to have_css("a", text: I18n.t('products.new_product'))
  end

  scenario 'display new product form' do
    click_link(I18n.t('products.new_product'))

    expect(page).to have_content(I18n.t('products.new_product'))
    expect(page).to have_css("a", text: I18n.t('global.back'))
    expect(page).to have_button(I18n.t('products.create_product'))
    expect(page).to have_css("a", text: I18n.t('global.cancel'))
  end

  scenario 'submit new product form with blank values', js: true do
    click_link(I18n.t('products.new_product'))

    within("#product_form") do
      fill_in "product_name", with: ""
      fill_in "product_sku", with: ""
      fill_in "product_price", with: ""
      fill_in "product_quantity", with: ""
    end

    click_button I18n.t('products.create_product')

    expect(page).to have_selector("label.error", count: 4)
    expect(page).to have_content("Please enter name.")
    expect(page).to have_content("Please enter sku.")
    expect(page).to have_content("Please enter price.")
    expect(page).to have_content("Please enter quantity.")
  end

  scenario 'submit new product form with invalid values', js: true do
    click_link(I18n.t('products.new_product'))

    within("#product_form") do
      fill_in "product_name", with: FFaker::Lorem.word
      fill_in "product_sku", with: "    "
      fill_in "product_price", with: FFaker::Lorem.word
      fill_in "product_quantity", with: FFaker::Lorem.word
    end

    click_button I18n.t('products.create_product')

    expect(page).to have_selector("label.error", count: 3)
    expect(page).to have_content("Please enter valid sku.")
    expect(page).to have_content("Please enter a valid number.")
    expect(page).to have_content("Please enter a valid number.")
  end

  scenario 'submit new product form with valid values', js: true do
    click_link(I18n.t('products.new_product'))

    within("#product_form") do
      fill_in "product_name", with: FFaker::Lorem.word
      fill_in "product_sku", with: FFaker::Product.model
      fill_in "product_price", with: 100
      fill_in "product_quantity", with: 1000
    end

    click_button I18n.t('products.create_product')

    expect(page).to have_content(I18n.t('products.created'))
  end

  scenario 'display product' do
    click_link(I18n.t('global.show'))

    expect(page).to have_content(product.name)
    expect(page).to have_content(product.sku)
    expect(page).to have_content(product.price)
    expect(page).to have_content(product.quantity)
    expect(page).to have_css("a", text: I18n.t('global.back'))
    expect(page).to have_css("a", text: I18n.t('products.edit_product'))
  end

  scenario 'edit product' do
    click_link(I18n.t('global.edit'))

    expect(page).to have_content(I18n.t('products.editing_product'))
    expect(find_field(id: 'product_name').value).to eq product.name
    expect(find_field(id: 'product_sku').value).to eq product.sku
    expect(find_field(id: 'product_price').value).to eq product.price.to_s
    expect(find_field(id: 'product_quantity').value).to eq product.quantity.to_s
    expect(page).to have_button(I18n.t('products.update_product'))
    expect(page).to have_css("a", text: I18n.t('global.cancel'))
  end

  scenario 'update product form with blank values', js: true do
    click_link(I18n.t('global.edit'))

    within("#product_form") do
      fill_in "product_name", with: ""
      fill_in "product_sku", with: ""
      fill_in "product_price", with: ""
      fill_in "product_quantity", with: ""
    end

    click_button I18n.t('products.update_product')

    expect(page).to have_selector("label.error", count: 4)
    expect(page).to have_content("Please enter name.")
    expect(page).to have_content("Please enter sku.")
    expect(page).to have_content("Please enter price.")
    expect(page).to have_content("Please enter quantity.")
  end

  scenario 'update product form with invalid values', js: true do
    click_link(I18n.t('global.edit'))

    within("#product_form") do
      fill_in "product_name", with: FFaker::Lorem.word
      fill_in "product_sku", with: "    "
      fill_in "product_price", with: FFaker::Lorem.word
      fill_in "product_quantity", with: FFaker::Lorem.word
    end

    click_button I18n.t('products.update_product')

    expect(page).to have_selector("label.error", count: 3)
    expect(page).to have_content("Please enter valid sku.")
    expect(page).to have_content("Please enter a valid number.")
    expect(page).to have_content("Please enter a valid number.")
  end

  scenario 'update product form with valid values', js: true do
    click_link(I18n.t('global.edit'))

    within("#product_form") do
      fill_in "product_name", with: FFaker::Lorem.word
      fill_in "product_sku", with: FFaker::Product.model
      fill_in "product_price", with: 100
      fill_in "product_quantity", with: 1000
    end

    click_button I18n.t('products.update_product')

    expect(page).to have_content(I18n.t('products.updated'))
  end
end
