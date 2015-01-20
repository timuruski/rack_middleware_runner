app = Proc.new do |env|
  headers = {'Content-type' => 'application/json'}
  body = ['{"name": "Monitor"}']

  [200, headers, body]
end

run app
