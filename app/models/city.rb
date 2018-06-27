# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class City < ApplicationRecord
	has_many :cinemas
	validates :name, presence: true, uniqueness: true
	validates :id, presence: true, uniqueness: true
end
