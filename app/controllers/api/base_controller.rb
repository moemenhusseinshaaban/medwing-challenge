module Api
  class BaseController < ActionController::API
    include Concerns::ErrorHandler
    before_action :authenticate_thermostat

    attr_reader :thermostat_id

    private

    def authenticate_thermostat
      @thermostat_id = AuthenticateApiRequestService.new(request.headers).call
      render_401 unless @thermostat_id
    end
  end
end
