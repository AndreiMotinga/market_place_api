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

  describe 'POST #create' do
    context 'when is successfully created' do
      before do
        @user_attributes = attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      it { should respond_with 201 }

      it 'renders the json representation for the user record just created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end
    end

    context 'when is not created' do
      before do
        invalid_user_attributes = { password: '12345678',
                                    password_confirmation: '12345678' }
        post :create, params: { user: invalid_user_attributes }
      end

      it { should respond_with 422 }

      it 'renders an errors json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end
end
