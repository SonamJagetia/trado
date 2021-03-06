# == Schema Information
#
# Table name: products
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  weighting         :integer
#  part_number       :integer
#  sku               :string
#  category_id       :integer
#  slug              :string
#  meta_description  :string
#  featured          :boolean
#  active            :boolean          default(TRUE)
#  short_description :text
#  status            :integer          default(0)
#  order_count       :integer          default(0)
#  page_title        :string
#

FactoryGirl.define do
    factory :product do
        sequence(:name)  { |n| "#{Faker::Lorem.word}#{Faker::Lorem.characters(8)}#{n}" }
        page_title { Faker::Lorem.characters(30) }
        meta_description { Faker::Lorem.characters(10) }
        short_description { Faker::Lorem.characters(15) } 
        description { Faker::Lorem.characters(20) }
        sku { Faker::Lorem.characters(5) }
        sequence(:part_number) { |n| n }
        featured { false }
        active { false }
        sequence(:weighting) { |n| n }
        status { 'draft' }
        order_count { 0 }

        association :category

        after(:create) do |product|
            create(:product_attachment, attachable: product)
        end

        factory :product_sku_attachment do
            active { true }
            status { 'published' }
            after(:build) do |product|
                product.skus << build(:sku, product: nil, active: true)
                product.attachments << build(:product_attachment, attachable: nil)
            end

            factory :product_accessory do
                accessories { [create(:accessory)] }
            end

            factory :product_no_slug do
                slug { nil }
            end
        end

        factory :product_sku do
            after(:create) do |product|
                create(:sku, product: product, code: '55', active: true)
            end

            factory :multiple_attachment_product do
                after(:create) do |product|
                    create(:product_attachment, attachable: product)
                end
            end

            factory :tags_with_product do
                tags { [create(:tag, name: 'tag #1'), create(:tag, name: 'tag #2'), create(:tag, name: 'tag #3')] }
            end 
        end

        factory :product_skus do 
            after(:create) do |product|
                create_list(:sku, 3, product: product, active: true)
            end
        end

        factory :build_product_skus do
            active { true }
            status { 'published' }
            skus { build_list(:sku, 3, active: true) }
        end

        factory :build_product_attachment do
            active { true }
            status { 'published' }
            attachments { build_list(:product_attachment, 2) }
        end

        factory :product_sku_stock_count do
            after(:create) do |product|
                create(:sku, product: product, stock: 10, active: true)
            end
        end

        factory :notified_product do
            after(:create) do |product|
                create(:sku_in_stock, product: product)
            end
        end

        factory :invalid_product do
            name { nil }
        end

        # Factories for stock_spec:automated stock warning level
        factory :stock_warning_product_1 do
            after(:create) do |product|
                build(:sku, product: product, stock: 5, stock_warning_level: 10).save(validate: false)
            end
        end
        factory :stock_warning_product_2 do
            after(:create) do |product|
                build(:sku, product: product, stock: 20, stock_warning_level: 5).save(validate: false)
            end
        end
        factory :stock_warning_product_3 do
            after(:create) do |product|
                build(:sku, product: product, stock: 7, stock_warning_level: 15).save(validate: false)
            end
        end
    end
end
