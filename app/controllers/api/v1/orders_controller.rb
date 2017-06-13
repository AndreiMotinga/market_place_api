class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!

  def index
    render json: current_user.orders
  end

  def show
    render json: current_user.orders.find(params[:id])
  end
end
