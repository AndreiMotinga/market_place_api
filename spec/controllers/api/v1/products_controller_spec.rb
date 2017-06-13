require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe 'GET #show' do
    before do
      @product = create :product
      get :show, params: { id: @product.id }
    end

    it { should respond_with 200 }

    it 'returns the information about a reporter on a hash' do
      expect(json_response[:title]).to eql @product.title
    end
  end

  describe 'GET #index' do
    before(:each) do
      4.times { create :product }
      get :index
    end

    it { should respond_with 200 }

    it 'returns 4 records from the database' do
      expect(json_response[:products]).to have(4).items
    end
  end
end
