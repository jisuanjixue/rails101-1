class Movie < ApplicationRecord
  validate :title, :presence: true
end
