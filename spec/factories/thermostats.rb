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

FactoryBot.define do
  factory :thermostat do
    household_token { FFaker::Identification.ssn }
    location { FFaker::Address.building_number }
  end
end
