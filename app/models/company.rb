class Company < ApplicationRecord
  belongs_to :source
  has_many :currencies
  has_many :categories
  has_many :offers
end
