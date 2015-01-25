require_relative '../environment'

require 'rack/cors'
require 'package'
require 'runner_app'

packages = Entries.map { |name|
  package_path = "#{name}/lib/middleware.rb"
  [name, Package.new(package_path)]
}

class AlwaysAuthorize
  def initialize(app)
    @app = app
  end

  def call(env)
    env['rack.current_user'] = Users.first
    @app.call(env)
  end
end

packages.each do |name, package|
  name = File.basename(name)
  map "/entries/#{name}" do
    use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any
      end
    end

    # use WithPry
    use package::LogErrors
    use AlwaysAuthorize
    # use package::Authorize, Users
    use package::JsonP

    run RunnerApp.new
  end
end
