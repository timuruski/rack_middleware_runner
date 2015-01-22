require 'bundler/setup'
require 'pathname'
require 'yaml'

$LOAD_PATH.unshift File.expand_path '../lib', __FILE__

class Model
  def self.new(*attrs)
    Struct.new(*attrs) do
      def self.load(attrs)
        attrs.each_with_object(new) { |(key, value), obj|
          obj.send("#{key}=", value) }
      end

      yield if block_given?
    end
  end
end

class Repository
  def self.load(model, path)
    yaml = File.read File.expand_path(path)
    objects = YAML.load(yaml).map { |attrs| model.load(attrs) }

    repo = new(objects)
    class << repo
      yield if block_given?
    end

    repo
  end

  def initialize(objects)
    @objects = objects
  end

  def find(id)
    id = id.to_i
    @objects.find { |obj| obj.id == id }
  end

  def all
    @objects.to_a
  end
end

class User < Model.new(:id, :name, :token); end
class Report < Model.new(:id, :user_id, :title); end

Users = Repository.load(User, 'data/users.yml') do
  def find_by_token(token)
    token = token.to_s
    @objects.find { |user| user.token == token }
  end
end

Reports = Repository.load(Report, 'data/reports.yml') do
  def find_for_user(user, report_id)
    user_id = user.id
    @objects.find { |report|
      report.user_id == user_id &&
        report.id == report_id
    }
  end
end
