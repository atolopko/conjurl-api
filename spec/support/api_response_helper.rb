module ApiResponseHelper
  def response_data
    JSON.parse(response.body, symbolize_names: true)
  end
end
