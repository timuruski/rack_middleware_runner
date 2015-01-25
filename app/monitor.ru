require_relative '../environment'

require 'monitor_app'

# use WithPry, Proc.new { |env| env['PATH_INFO'] =~ /entries/ }
run MonitorApp.new
