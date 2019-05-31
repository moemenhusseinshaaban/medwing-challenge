# == Schema Information
#
# Table name: readings
#
#  battery_charge :float
#  humidity       :float
#  id             :integer          not null, primary key
#  number         :bigint
#  temperature    :float
#  thermostat_id  :integer
#
# Indexes
#
#  index_readings_on_thermostat_id             (thermostat_id)
#  index_readings_on_thermostat_id_and_number  (thermostat_id,number) UNIQUE
#

class Reading < ApplicationRecord
  belongs_to :thermostat
  validates :thermostat_id, presence: true
  validates :temperature, :humidity, :battery_charge, presence: true, numericality: {only_float: true}
end
