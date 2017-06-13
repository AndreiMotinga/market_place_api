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
  end
end
