# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Thermostat.count == 0
  3.times.each do |index|
    index+=1
    Thermostat.create(household_token: "THERMO##{index}", location: "room#{index}")
    success_message = "#{Time.zone.now} Thermostat number (#{index}) Has Been Successfully Created"
    Rails.logger.info success_message
    p "THERMO##{index}"
  end
end
