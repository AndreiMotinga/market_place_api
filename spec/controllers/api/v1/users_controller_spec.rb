require 'rails_helper'

describe Api::V1::UsersController do
  before { request.headers['Accept'] = 'application/vnd.marketplace.v1' }

  describe 'GET #show' do
    before do
      @user = FactoryGirl.create :user
      get :show, params: { id: @user.id, format: :json }
    end

    it 'returns the information about a reporter on a hash' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end
end
