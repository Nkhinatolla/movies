# == Schema Information
#
# Table name: cinemas
#
#  id         :integer          not null, primary key
#  name       :string
#  city_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cinema < ApplicationRecord
	belongs_to :city
	has_many :sessions
	has_many :movies, through: :sessions
	validates :name, presence: true
	validates :id, presence: true, uniqueness: true
	validates :city_id, presence: true
end
