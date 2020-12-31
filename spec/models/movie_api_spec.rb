require 'rails_helper'

describe Movie, type: :model do
  describe "relationships" do
    it { should have_many :parties }
  end

  describe "validations" do
    it { should validate_presence_of :api_id }
    it { should validate_presence_of :title }
  end
end
