class ThermostatCachingService
  class << self
    def initialize_thermostat_cache(thermostat)
      @thermostat_id = thermostat.id
      @readings = thermostat.readings
      Rails.cache.write("thermo_#{thermostat.id}_reading_count", @readings.size)
      Rails.cache.write("thermo_#{thermostat.id}_reading_number", @readings.last&.number || 0)
      @readings.size == 0 ? create_statistics_cache : calculate_statistics_cache
    end

    def cache_new_reading(reading)
      @thermostat_id = reading.thermostat_id
      @reading = reading
      Rails.cache.write("#{@thermostat_id}/#{@reading.number}", @reading.attributes.except!('id'))
      update_statistics_cache
    end

    %w[number count].each do |property|
      define_method("update_reading_#{property}") do |thermostat_id|
        number = Rails.cache.read("thermo_#{thermostat_id}_reading_#{property}") + 1
        Rails.cache.write("thermo_#{thermostat_id}_reading_#{property}", number)
        number
      end
    end

    private

    def create_statistics_cache
      Rails.cache.write("thermo_#{@thermostat_id}_statistics", {})
    end

    def update_statistics_cache
      statistics = Rails.cache.read("thermo_#{@thermostat_id}_statistics")
      reading_old_count = Rails.cache.read("thermo_#{@thermostat_id}_reading_count")
      %w[temperature humidity battery_charge].each do |property|
        statistics["min_#{property}"] = @reading.send(property) if statistics["min_#{property}"].blank? || statistics["min_#{property}"] > @reading.send(property)
        statistics["max_#{property}"] = @reading.send(property) if statistics["max_#{property}"].blank? || statistics["max_#{property}"] < @reading.send(property)
        current_average = statistics["average_#{property}"] || 0
        statistics["average_#{property}"] = ArrayCalculation.new_average(@reading.send(property), current_average, reading_old_count)
      end
      update_reading_count(@thermostat_id)
      Rails.cache.write("thermo_#{@thermostat_id}_statistics", statistics)
    end

    def calculate_statistics_cache
      statistics = {}
      %w[temperature humidity battery_charge].each do |property|
        array_property = @readings.pluck(property)
        statistics["min_#{property}"] = array_property.min
        statistics["max_#{property}"] = array_property.max
        statistics["average_#{property}"] = ArrayCalculation.average(array_property)
      end
      Rails.cache.write("thermo_#{@thermostat_id}_statistics", statistics)
    end
  end
end
