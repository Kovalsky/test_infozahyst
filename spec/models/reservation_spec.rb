require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:restaurant) { create(:restaurant, open_time: 3600 * 15, close_time: 3600 * 1) }
  let(:user) { create(:user) }

  it "is not valid without a user" do
    reservation = build(:reservation, restaurant: restaurant)
    expect(reservation).not_to be_valid
  end

  it "is not valid without a restaurant" do
    reservation = build(:reservation, user: user)
    expect(reservation).not_to be_valid
  end

  describe "overlaping" do

    describe "when reservation occurs partialy befor restaurant open time" do
      it "is not valid" do
        reservation = build(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 14, end_time: 3600 * 16)
        expect(reservation).not_to be_valid
      end
    end

    describe "when reservation occurs partialy after restaurant close time" do
      it "is not valid" do
        reservation = build(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 23, end_time: 3600 * 2)
        expect(reservation).not_to be_valid
      end
    end

    let(:reservation_b) { create(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 16, end_time: 3600 * 18) }

    describe "when a occurs partialy after b" do
      it "is not valid" do
        restaurant.reservations << reservation_b
        reservation_a = build(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 17.5, end_time: 3600 * 19)
        expect(reservation_a).not_to be_valid
      end
    end
    describe "when a occurs partialy befor b" do
      it "is not valid" do
        restaurant.reservations << reservation_b
        reservation_a = build(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 15, end_time: 3600 * 16.5)
        expect(reservation_a).not_to be_valid
      end
    end
    describe "when a sorrounds b" do
      it "is not valid" do
        restaurant.reservations << reservation_b
        reservation_a = build(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 15, end_time: 3600 * 19)
        expect(reservation_a).not_to be_valid
      end
    end
    describe "when b sorrounds a" do
      it "is not valid" do
        restaurant.reservations << reservation_b
        reservation_a = build(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 16.5, end_time: 3600 * 17)
        expect(reservation_a).not_to be_valid
      end
    end
    describe "when a occurs entirely after b" do
      it "is be valid" do
        restaurant.reservations << reservation_b
        reservation_a = build(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 18, end_time: 3600 * 19)
        expect(reservation_a).to be_valid
      end
    end
    describe "when b occurs entirely after a" do
      it "is be valid" do
        restaurant.reservations << reservation_b
        reservation_a = build(:reservation, restaurant: restaurant, user: user, start_time: 3600 * 15, end_time: 3600 * 16)
        expect(reservation_a).to be_valid
      end
    end
  end
end
