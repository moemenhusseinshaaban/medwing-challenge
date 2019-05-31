module Api
  class ReadingsController < Api::BaseController
    def create
      reading = Reading.new(permitted_params)
      reading.thermostat_id = @thermostat_id
      (render_422('Invalid Record') && return) unless reading.valid?
      reading.number = ThermostatCachingService.update_reading_number(@thermostat_id)
      render_201 cache_and_save(reading)
    end

    def show
      json_result = Rails.cache.read("#{@thermostat_id}/#{params[:id]}") || Reading.find_by(number: params[:id], thermostat_id: @thermostat_id)
      (render_404("Record not found") && return) if json_result.blank?
      render_200(json_result)
    end

    private

    def cache_and_save(reading)
      ThermostatCachingService.cache_new_reading reading
      SaveReadingWorker.perform_async(reading.attributes)
      { reading_id: reading.number}
    end

    def permitted_params
      params.require(:reading).permit(:temperature, :humidity, :battery_charge)
    end
  end
end
