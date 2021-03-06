require 'bundler/setup'
require 'pry-remote'

class WithPry
  ALWAYS = Proc.new { true }

  def initialize(app, condition = ALWAYS)
    @app = app
    @condition = condition
  end

  def call(env)
    binding.remote_pry if @condition.call(env)
    @app.call(env)
  end
end


$LOAD_PATH.unshift File.expand_path '../lib', __FILE__

require 'pathname'
require 'yaml'

Entries = Dir.glob('vendor/*').select { |name| File.directory?(name) }

class Model
  def self.new(*attrs)
    Struct.new(*attrs) do
      def self.load(attrs)
        attrs.each_with_object(new) { |(key, value), obj| obj[key] = value }
      end

      yield if block_given?
    end
  end
end

class Repository
  def self.load(model, path, &block)
    yaml = File.read File.expand_path(path)
    objects = YAML.load(yaml).map { |attrs| model.load(attrs) }
    new(objects, &block)
  end

  def initialize(objects, &block)
    @objects = objects
    extend Module.new(&block) if block
  end

  def find(id)
    id = id.to_i
    @objects.find { |obj| obj.id == id }
  end

  def all
    @objects.to_a
  end

  def first
    @objects.first
  end
end

class User < Model.new(:id, :name, :token); end
class Report < Model.new(:id, :body); end

Users = Repository.load(User, 'data/users.yml') do
  def find_by_token(token)
    token = token.to_s
    @objects.find { |user| user.token == token }
  end
end

Reports = Repository.load(Report, 'data/reports.yml') do
  def find_for_user(user, report_id)
    user_id = user.id
    report_id = report_id.to_i

    @objects.find { |report|
      report.user_id == user_id &&
        report.id == report_id
    }
  end
end
