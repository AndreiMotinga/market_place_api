require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  describe 'GET #index' do
    before do
      current_user = create :user
      request.headers['Authorization'] = current_user.auth_token
      4.times { create :order, user: current_user }
      get :index, params: { user_id: current_user.id }
    end

    it { should respond_with 200 }

    it 'returns 4 order records from the user' do
      expect(json_response[:orders].size).to eq 4
    end

    it_behaves_like 'paginated list'
  end

  describe 'GET #show' do
    before do
      current_user = create :user
      request.headers["Authorization"] = current_user.auth_token
      @product = create :product
      @order = create :order, user: current_user, product_ids: [@product.id]
      get :show, params: { user_id: current_user.id, id: @order.id }
    end

    it { should respond_with 200 }

    it 'returns the user order record matching the id' do
      order_response = json_response[:order]
      expect(order_response[:id]).to eql @order.id
    end

    it 'includes the total for the order' do
      order_response = json_response[:order]
      expect(order_response[:total]).to eql @order.total.to_s
    end

    it 'includes the products on the order' do
      order_response = json_response[:order]
      expect(order_response[:products].size).to eq 1
    end
  end

  describe 'POST #create' do
    before do
      current_user = create :user
      request.headers['Authorization'] = current_user.auth_token
      product1 = create :product
      product2 = create :product
      order_params = { product_ids: [product1.id, product2.id] }
      post :create, params: { user_id: current_user.id, order: order_params }
    end

    it { should respond_with 201 }

    it 'returns the just user order record' do
      order_response = json_response[:order]
      expect(order_response[:id]).to be_present
    end
  end

end
