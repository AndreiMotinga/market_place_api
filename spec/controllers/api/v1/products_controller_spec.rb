require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe 'GET #show' do
    before do
      @product = create :product
      get :show, params: { id: @product.id }
    end

    it { should respond_with 200 }

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:product][:title]).to eql @product.title
    end

    it 'has the user as a embeded object' do
      product_response = json_response[:product]
      expect(product_response[:user][:email]).to eql @product.user.email
    end
  end

  describe 'GET #index' do
    before(:each) do
      4.times { create :product }
      get :index
    end

    it { should respond_with 200 }

    it 'returns 4 records from the database' do
      expect(json_response[:products].size).to eq 4
    end

    it 'returns the user object into each product' do
      products_response = json_response[:products]
      products_response.each do |product_response|
        expect(product_response[:user]).to be_present
      end
    end

    context "when is not receiving any product_ids parameter" do
      before { get :index }

      it { should respond_with 200 }

      it "returns 4 records from the database" do
        products_response = json_response
        expect(products_response[:products].size).to eq 4
      end

      it "returns the user object into each product" do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      it { expect(json_response).to have_key(:meta) }
      it { expect(json_response[:meta]).to have_key(:pagination) }
      it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
      it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
      it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }

      it { should respond_with 200 }
    end

    context 'when product_ids parameter is sent' do
      before(:each) do
        @user = create :user
        create_list :product, 3, user: @user
        get :index, params: { product_ids: @user.product_ids }
      end

      it 'returns just the products that belong to the user' do
        products_response = json_response[:products]
        products_response.each do |product_response|
          expect(product_response[:user][:email]).to eql @user.email
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before do
        user = create :user
        @product_attributes = attributes_for :product
        request.headers['Authorization'] = user.auth_token
        attrs = { user_id: user.id, product: @product_attributes }
        post :create, params: attrs
      end

      it { should respond_with 201 }

      it 'renders the json representation for the product record just created' do
        expect(json_response[:product][:title]).to eql @product_attributes[:title]
      end
    end

    context 'when is not created' do
      before do
        user = create :user
        @invalid_product_attributes = { title: 'Smart TV',
                                        price: 'Twelve dollars' }
        request.headers['Authorization'] = user.auth_token
        attrs = { user_id: user.id, product: @invalid_product_attributes }
        post :create, params: attrs
      end

      it { should respond_with 422 }

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors][:price]).to include 'is not a number'
      end
    end
  end

  describe 'PUT/PATCH #update' do
    before do
      @user = create :user
      @product = create :product, user: @user
      request.headers['Authorization'] = @user.auth_token
    end

    context 'when is successfully updated' do
      before do
        attrs = { user_id: @user.id,
                  id: @product.id,
                  product: { title: 'An expensive TV' } }
        patch :update, params: attrs
      end

      it { should respond_with 200 }

      it 'renders the json representation for the updated user' do
        expect(json_response[:product][:title]).to eql 'An expensive TV'
      end
    end

    context 'when is not updated' do
      before do
        attrs = { user_id: @user.id,
                  id: @product.id,
                  product: { price: 'two hundred' } }
        patch :update, params: attrs
      end

      it { should respond_with 422 }

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors on whye the user could not be created' do
        expect(json_response[:errors][:price]).to include 'is not a number'
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      request.headers['Authorization'] = @user.auth_token
      delete :destroy, params: { user_id: @user.id, id: @product.id }
    end

    it { should respond_with 204 }
  end
end
