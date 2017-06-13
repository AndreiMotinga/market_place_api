require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should validate_presence_of :user_id }

  it { should belong_to :user }
  it { should have_many(:placements) }
  it { should have_many(:products).through(:placements) }

  describe '#set_total!' do
    before do
      product_1 = create :product, price: 100
      product_2 = create :product, price: 85
      @order = build :order, product_ids: [product_1.id, product_2.id]
    end

    it 'returns the total amount to pay for the products' do
      expect{ @order.set_total! }.to change { @order.total }.from(0).to(185)
    end
  end
end
