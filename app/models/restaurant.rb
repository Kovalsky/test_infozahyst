class Restaurant < ApplicationRecord
  has_many :reservations

  def close_time=(val)
    close_time = val < open_time ? val + 3600 * 24 : val
    super(close_time)
  end
end
