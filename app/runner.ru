require_relative '../environment'
require_relative '../lib/package'

app = Proc.new do |env|
  headers = {'Content-type' => 'application/json'}
  body = ['{"message":"Hello world"}']

  [200, headers, body]
end

user_repo = UserRepo.new('abc123' => User.new)

packages = Dir.glob('vendor/*')
    .select { |name| File.directory?(name) }
    .map { |name|
      package_path = "#{name}/lib/middleware.rb"
      [name, Package.new(package_path)]
    }

packages.each do |name, package|
  name = File.basename(name)
  map "/entries/#{name}" do
    use package::LogErrors
    use package::Authorize, user_repo
    use package::JsonP

    run app
  end
end
