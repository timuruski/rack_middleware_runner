require 'bundler/setup'

$LOAD_PATH.unshift File.expand_path '../lib', __FILE__

class User; end
class UserRepo
  def initialize(users = {})
    @users = users
  end

  def find_by_token(token)
    @users[token]
  end
end

__END__

require 'sequel'

class User < Struct.new(:name, :email, :token)
  alias_method :to_json, :to_h
  class << self
    REPO = [
      new('alice', 'alice@example.org', 'abc123'),
      new('bob', 'bob@example.org', 'def234'),
      new('charlie', 'charlie@example.org', 'ghi345')
    ]

    def find(id)
      REPO[id - 1]
    end

    def find_by_token(token)
      REPO.find { |user| user.token == token }
    end
  end
end

class Post < Struct.new(:title, :body)
  alias_method :to_json, :to_h
end
