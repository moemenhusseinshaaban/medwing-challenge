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

FactoryBot.define do
  factory :reading do
    thermostat
    sequence(:number) { |n| n }
    temperature { FFaker::Random.rand }
    humidity { FFaker::Random.rand }
    battery_charge { FFaker::Random.rand }
  end
end
