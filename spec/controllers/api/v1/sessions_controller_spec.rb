require 'rails_helper'

describe Api::V1::SessionsController do
  describe 'POST #create' do
    before { @user = create :user }

    context 'when the credentials are correct' do
      before do
        credentials = { email: @user.email, password: '12345678' }
        post :create, params: { session: credentials }
      end

      it { should respond_with 200 }

      it 'returns the user record corresponding to the given credentials' do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end
    end

    context "''" do
      before do
        credentials = { email: @user.email, password: 'invalidpassword' }
        post :create, params: { session: credentials }
      end

      it { should respond_with 422 }

      it 'returns a json with an error' do
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      @user = create :user
      @old_token = @user.auth_token
      sign_in @user
      delete :destroy, params: { id: @user.auth_token }
    end

    it { should respond_with 204 }

    it "regenerates user.auth_token" do
      @user.reload
      expect(@user.auth_token).to_not eq @old_token
    end
  end
end
