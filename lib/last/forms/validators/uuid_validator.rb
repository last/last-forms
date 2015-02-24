require "active_model"

module Last
module Forms
module Validators

class UuidValidator < ActiveModel::EachValidator

  UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i.freeze

  def validate_each(record, attr, values)
    Array(values).each do |value|
      if !value.nil? && value !~ UUID_REGEX
        record.errors.add attr, "#{value} is not a valid UUID"
        break
      end
    end
  end
end

end
end
end
