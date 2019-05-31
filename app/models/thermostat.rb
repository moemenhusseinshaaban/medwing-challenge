# == Schema Information
#
# Table name: thermostats
#
#  household_token :text
#  id              :integer          not null, primary key
#  location        :text
#
# Indexes
#
#  index_thermostats_on_household_token  (household_token) UNIQUE
#

class Thermostat < ApplicationRecord
  has_many :readings
  validates :household_token, presence: true

  def auth_token
    JsonWebToken.encode(thermostat_id: id)
  end
end
