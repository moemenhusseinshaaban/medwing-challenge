module Api
  class ThermostatsController < Api::BaseController
    def statistics
      calculate_statistics if Rails.cache.read("thermo_#{@thermostat_id}_statistics").blank?
      json_result = Rails.cache.read("thermo_#{@thermostat_id}_statistics")
      render_200(json_result)
    end

    private

    def calculate_statistics
      thermostat = Thermostat.where(id: @thermostat_id).includes(:readings).first
      ThermostatCachingService.initialize_thermostat_cache thermostat
    end
  end
end
