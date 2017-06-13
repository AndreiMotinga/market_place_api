require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :total}
  it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }

  it { should belong_to :user }
end
