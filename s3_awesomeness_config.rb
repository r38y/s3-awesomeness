require 'rubygems'
require 'yaml'

ENV['S3CONF'] = File.dirname(__FILE__)
CONF = YAML.load_file(File.join(ENV['S3CONF'], 's3config.yml'))

S3SYNC = File.join(File.dirname(__FILE__), 'vendor', 's3sync', 's3sync.rb')
CACHE = File.join(File.dirname(__FILE__), 'cache')
