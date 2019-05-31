module Api
  class AuthenticationController < Api::BaseController
    skip_before_action :authenticate_thermostat

    def authenticate
      (render_422('Required Household Token') && return) unless params[:household_token]
      token = AuthenticationService.new(params[:household_token]).call
      (render_401('Invalid Household Token') && return) if token.blank?
      render_200({ authentication_token: token })
    end
  end
end
