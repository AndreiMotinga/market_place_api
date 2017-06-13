class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!

  def index
    orders = current_user.orders.page(params[:page]).per(params[:per_page])
    render json: orders, meta: pagination(orders, params[:per_page])
  end

  def show
    render json: current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.build(order_params)

    if order.save
      render json: order, status: 201, location: [:api, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end

  private

  def order_params
    params.require(:order).permit(product_ids: [])
  end
end
