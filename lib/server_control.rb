# main module of application
module PokuponDeamon
  require 'daemons'

  config = YAML.safe_load(
    File.read(
      File.expand_path('../../config/application.yml', __FILE__)
    )
  )
  config.each do |key, value|
    ENV[key] = value unless value.is_a? Hash
  end

  Daemons.run('lib/server.rb')
end
