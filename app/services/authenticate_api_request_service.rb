class AuthenticateApiRequestService

  def initialize(headers = {})
    @headers = headers
  end

  def call
    thermostat_id
  end

  private

  attr_reader :headers

  def thermostat_id
    @thermostat_id ||= decoded_auth_token[:thermostat_id] if decoded_auth_token
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    headers['Authorization'].split(' ').last if headers['Authorization'].present?
  end
end
