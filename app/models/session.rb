# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  cinema_id  :integer
#  open       :boolean          default(TRUE)
#  time       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Session < ApplicationRecord
	belongs_to :movie
	belongs_to :cinema
	validates :movie_id, presence: true
	validates :open, presence: true
	validates :time, presence: true
end
