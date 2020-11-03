class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant

  validates_presence_of :user
  validates_presence_of :restaurant

  validates_with ReservationTimeValidator

  def end_time=(val)
    end_time = val < start_time ? val + 3600 * 24 : val
    super(end_time)
  end
end
