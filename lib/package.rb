# Loads Ruby code without polluting the global namespace. Does the least amount
# of work possible, but should probably be expanded later.
#
# Inspired by the Script library: http://redshift.sourceforge.net/script/
class Package < Module
  # Used to store scope for require_relative.
  PREAMBLE = "@relative_paths.unshift File.dirname(__FILE__)\n"

  def initialize(path)
    @initial_path = File.expand_path(path)
    @base_dir = File.dirname(@initial_path)
    @relative_paths = []
    @loaded_features = {}

    load_in_self(@initial_path)
  end

  def load(path, wrapped = false)
    load_in_self(path)
    true
  rescue MissingFile
    super
  end

  def require(feature)
    return false if @loaded_features[feature]

    @loaded_features[feature] = true
    path = File.expand_path(feature, @base_dir)
    path += '.rb' unless path.end_with?('.rb')

    load_in_self(path)
    true
  rescue MissingFile
    super
  end

  def require_relative(path)
    base_dir = @relative_paths.first
    path = File.expand_path(path, base_dir)
    require(path)
  rescue MissingFile
    super
  end

  private

  class MissingFile < LoadError; end

  def load_in_self(path)
    module_eval(PREAMBLE + IO.read(path), File.expand_path(path), 0)
    @relative_paths.shift
  rescue Errno::ENOENT => error
    if /#{path}$/ =~ error.message
      raise MissingFile, error.message
    else
      raise
    end
  end
end


# DEMO
if $0 == __FILE__
  Foo = Package.new('lib/authorize.rb')
  Bar = Package.new('lib/authorize.rb')

  puts Foo::Authorize
  puts Bar::Authorize
  puts Bar::Authorize.new
end
