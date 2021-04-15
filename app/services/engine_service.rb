class EngineService

  def self.all_purposes
    response = connection.get('/api/v1/purposes')
    data = response.body
    JSON.parse(data, symbolize_names: true)
  end

  def self.create_yard(yard_params)
    headers = {"CONTENT_TYPE" => "application/json"}
    response = connection.post('/api/v1/yards') do |req|
       req.headers["CONTENT_TYPE"] = "application/json"
       req.body = {yard: yard_params}.to_json
     end
  end

  def self.connection
    Faraday.new(url: ENV['ys_engine_url'])
  end
end