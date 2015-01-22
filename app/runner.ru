require_relative '../environment'

require 'package'
require 'runner_app'

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
    use package::Authorize, Users
    use package::JsonP

    run RunnerApp.new
  end
end
