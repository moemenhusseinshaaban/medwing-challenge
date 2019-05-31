class AuthenticationService
  def initialize(household_token)
    @household_token = household_token
  end

  def call
    return if thermostat.blank?
    ThermostatCachingService.initialize_thermostat_cache thermostat
    thermostat.auth_token
  end

  private

  attr_accessor :household_token

  def thermostat
    Thermostat.where(household_token: household_token).includes(:readings).first
  end
end
