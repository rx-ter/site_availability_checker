# main module of application
require 'daemons'
Daemons.run('lib/server.rb')
