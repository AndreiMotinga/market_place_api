class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :total, :created_at, :updated_at
end
