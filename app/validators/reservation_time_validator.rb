class ReservationTimeValidator < ActiveModel::Validator
  def validate(record)

    if has_overlaps?(record)
      record.errors.add(:base, "Can't create reservation for this time")
    end

    if invalid_duration?(record)
      record.errors.add(:base, "Invalid duration. Should be multiple by 30 min")
    end

    if invalid_schedule?(record)
      record.errors.add(:base, "Can't create reservation not in schedule time")
    end

  end

  def has_overlaps?(record)
    if restaurant = record.restaurant
      restaurant.reservations.where("start_time < ? AND ? < end_time", record.end_time, record.start_time).any?
    end
  end

  def invalid_duration?(record)
    record.start_time < record.end_time &&
      (record.end_time - record.start_time) % 1800 != 0
  end

  def invalid_schedule?(record)
    if restaurant = record.restaurant
      record.start_time < restaurant.open_time ||
        record.end_time >= restaurant.close_time
    end
  end
end
