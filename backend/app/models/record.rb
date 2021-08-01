class Record < ApplicationRecord
  belongs_to :user

	validades :title, :year, presence: true
end
