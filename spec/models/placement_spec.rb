require 'rails_helper'

RSpec.describe Placement, type: :model do
  it { should belong_to :order }
  it { should belong_to :product }
end
