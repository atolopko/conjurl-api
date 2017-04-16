module ApiAuthenticationHelper
  def authorization_header
    { 'Authorization' => "Bearer #{jwt}" }
  end

  def response_data
    JSON.parse(response.body, symbolize_names: true)
  end
end
