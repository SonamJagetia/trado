# == Schema Information
#
# Table name: carts
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  delivery_id          :integer
#  country              :string
#  delivery_service_ids :text
#

FactoryGirl.define do
    factory :cart do
    delivery_id { nil }
    country { Faker::Address.country }
        
        transient do
            cart_item_count 3
        end

        factory :full_cart do
            after(:create) do |cart, evaluator|
                create_list(:accessory_cart_item, evaluator.cart_item_count, cart: cart)
                create(:cart_item, cart: cart)
            end
        end

        factory :cart_order do
            after(:create) do |cart|
                create(:cart_item, cart: cart)
                create(:order, cart: cart)
            end
        end

        factory :tier_calculated_cart do
            after(:create) do |cart|
                sku_1 = create(:sku, weight: '14.5', length: '67.20', thickness: '12.34')
                sku_2 = create(:sku, weight: '4.67', length: '34.67', thickness: '9.81')
                create(:cart_item, cart: cart, sku_id: sku_1.id, weight: '14.5', price: 5.50, quantity: 5)
                create(:cart_item_1, cart: cart, sku_id: sku_2.id, weight: '8.17', price: 12.50, quantity: 3)
            end
        end
    end 
end
